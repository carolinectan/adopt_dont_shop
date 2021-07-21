class Application < ApplicationRecord
  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, numericality: true
  validates :application_status, presence: true

  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def pets_length?
    pets.length > 0
  end
end


# specific model -> specific controller for that model -> view / crud for that model
# single responsibility principle ^^ a model deals with one resource, a controller deals with one model, a view deals wiht one crud action for a specific model
