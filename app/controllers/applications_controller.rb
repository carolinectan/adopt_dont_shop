class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
  end

  def new
  end

  def create
    application = Application.create!(app_params)

    redirect_to "/applications/#{Application.last.id}"
  end

private
  def app_params
    params.permit(:name, :street, :city, :state, :zip_code, :description, :application_status)
  end
end
