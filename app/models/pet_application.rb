class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.find_by_pet_id_and_app_id(pet_id, app_id)
    self.where(pet_id: pet_id).where(application_id: app_id).first
  end
end
