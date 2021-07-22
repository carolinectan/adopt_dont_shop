class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])

    if params[:search]
      @pets = Pet.search(params[:search])
    # else
    #   @pets = Pet.adoptable
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
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])
    petapp = PetApplication.create!(pet: pet, application: application)

    redirect_to "/applications/#{application.id}"
  end

  def update_description
    application = Application.find(params[:id])

    application.update({
      description: params[:description],
      application_status: params[:application_status]
      })
    application.save

    redirect_to "/applications/#{application.id}"
  end

private
  def app_params
    params.permit(:name, :street, :city, :state, :zip_code, :description, :application_status, :pets)
  end
end
