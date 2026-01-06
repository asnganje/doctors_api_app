# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
    respond_to :json
    
    skip_before_action :verify_signed_out_user, only: :destroy

    def create
      user_params = params.require(:user).permit(:email, :password)
      user = User.find_by(email: user_params[:email])

    if user&.valid_password?(user_params[:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

      render json: {
        message: 'Logged in successfully',
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    auth_header = request.headers['Authorization']

    if auth_header.present?
      token = auth_header.split(' ').last

      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        jti     = payload['jti']
        exp     = Time.at(payload['exp'])
        if JwtDenylist.exists?(jti: jti)
          render json: { error: "Invalid or already logged out token" }, status: :unauthorized
        else
          JwtDenylist.create!(jti: jti, exp: exp)
          render json: { message: "Logged out successfully" }, status: :ok
        end
      rescue JWT::ExpiredSignature
        render json: {error:"Token has expired"}, status: :unauthorized 
      rescue => e
        Rails.logger.error "Unexpected JWT error #{e.message}"
        render json: {error: "Something went wrong"}, status: :unauthorized
      end
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  end
end
