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
      render json: { error:"Doctor not found!" }
    end
  end

  def create
    doctor = Doctor.new(doctor_params)
    if doctor.save
      render json: doctor, status: :created
    else
      render json: { errors: doctor.errors.full_messages}, status: :unprocessable_entity 
    end
  end

  def update
    if @doctor.update(doctor_params)
      render json: @doctor, status: :ok
    else
      render json: {errors: @doctor.errors.full_messages, status: :unprocessable_entity}
    end
  end

  def destroy
    if @doctor.destroy
      render json: {message: "Doctor successfully delete", status: :ok}
    else
      render json: { error: "Failed to delete doctor", status: :unprocessable_entity}
    end
  end

  private
  def set_doctor
    @doctor = Doctor.find(params[:id]) rescue nil
  end

  def doctor_params
    params.require(:doctor).permit(:name, :specialization, :biography, :picture)
  end
end
