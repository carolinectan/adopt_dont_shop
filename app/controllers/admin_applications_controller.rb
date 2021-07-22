class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])

    # try calling @application.application_pets for each of those find the status
    # google if you can access model.joins_table attribute
    # this way might be fine
    # @application.pets
    # @pet_applications = PetApplication.all
  end
end
