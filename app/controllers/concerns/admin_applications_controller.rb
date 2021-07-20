class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])

    @pet_applications = PetApplication.all
  end
end
