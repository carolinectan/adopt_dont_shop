class PetApplicationsController < ApplicationController
  def update
      pet_app = PetApplication.find_by_pet_id_and_app_id(params[:pet_id], params[:app_id])
    pet_app = pet_app.update(pet_app_status: params[:status])

    redirect_to "/admin/applications/#{params[:app_id]}"
  end
end
