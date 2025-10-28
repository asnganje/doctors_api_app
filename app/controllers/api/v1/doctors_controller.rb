class Api::V1::DoctorsController < ApplicationController
  before_action :set_doctor, only: [ :show, :update, :destroy ]

  def index
    doctors = Doctor.all
    render json: doctors
  end

  def show
    if @doctor
      render json: @doctor
    else
      render json: { error: "Doctor has not been found!" }
    end
  end

  def create
    file = params[:image]
    return render json: {error: "No image provided"}, status: :bad_request unless file

    begin
      image_url = SupabaseService.upload_file(ENV["SUPABASE_BUCKET"], file)
      
      @doctor = Doctor.new(
        name: params[:name],
        specialization: params[:specialization],
        biography: params[:biography],
        image_url: image_url
      )
      if @doctor.save
        render json: @doctor, status: :created
      else
        render json: { errors: @doctor.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: {error: e.message}, status: :internal_server_error
    end
  end

  def update
    if @doctor.update(doctor_params)
      render json: @doctor, status: :ok
    else
      render json: { errors: @doctor.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def destroy
    if @doctor.destroy
      render json: { 
        message: "Doctor successfully delete",
        doctor_id: @doctor.id,
        status: :ok 
      }
    else
      render json: { error: "Failed to delete doctor", status: :unprocessable_entity }
    end
  end

  private
  def set_doctor
    @doctor = Doctor.find(params[:id]) rescue nil
  end

  def doctor_params
    params.require(:doctor).permit(:name, :specialization, :biography, :image_url)
  end
end
