class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])

    if params[:search].present?
      @pets = Pet.search(params[:search])
    # else
    #   @pets = Pet.adoptable
    # binding.pry
    end

  end

  def new
  end

  def create
    application = Application.new(app_params)

    if application.save
      redirect_to "/applications/#{Application.last.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  def update
    app = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])
    petapp = PetApplication.create!(pet: pet, application: app)

    redirect_to "/applications/#{app.id}"
  end

private
  def app_params
    params.permit(:name, :street, :city, :state, :zip_code, :description, :application_status, :pets)
  end
end
