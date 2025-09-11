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
      # Decode JWT
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      jti     = payload['jti']
      exp     = Time.at(payload['exp'])

      # Check denylist
      if JwtDenylist.exists?(jti: jti)
        render json: { error: "Invalid or already logged out token" }, status: :unauthorized
      else
        JwtDenylist.create!(jti: jti, exp: exp)
        render json: { message: "Logged out successfully" }, status: :ok
      end
    rescue JWT::DecodeError, JWT::VerificationError
      render json: { error: "Invalid token" }, status: :unauthorized
    end
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
