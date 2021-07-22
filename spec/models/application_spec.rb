require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pet_applications) }
    it { should have_many(:pets).through(:pet_applications) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:application_status) }
    it { should validate_numericality_of(:zip_code) }
  end

  describe 'class methods' do
    it '#pets_length?' do
      @brighter_days = Shelter.create!(name: 'Brighter Days Shelter', rank: 1, city: 'Boulder', foster_program: true)

      @bosco = @brighter_days.pets.create!(name: 'Bosco', adoptable: true, age: 8, breed: 'Springer Spaniel')
      @lily = @brighter_days.pets.create!(name: 'Lily', adoptable: true, age: 5, breed: 'German Shepard Boxer Mix')
      @izze = @brighter_days.pets.create!(name: 'Izze', adoptable: true, age: 8, breed: 'Cocker Spaniel')
      @boogie = @brighter_days.pets.create!(name: 'Boogie', adoptable: true, age: 12, breed: 'Husky Samoyed Mix')

      @app_1 = Application.create!(name: 'Elliot O.', street: '5743 Squirrel Circle', city: 'Aspen', state: 'CO', zip_code: 81611, application_status: 'Pending', description: 'loves animals')
      @app_2 = Application.create!(name: 'Sami P.', street: '1123 Arbor Lane', city: 'Chicago', state: 'IL', zip_code: 60007, application_status: 'Approved', description: 'loving home')
      @app_3 = Application.create!(name: 'Amanda M.', street: '883 Teller Court', city: 'Wheat Ridge', state: 'CO', zip_code: 80033, application_status: 'In Progress')

      @pet_app_1 = PetApplication.create!(pet: @bosco, application: @app_1)
      @pet_app_2 = PetApplication.create!(pet: @lily, application: @app_1)
      @pet_app_3 = PetApplication.create!(pet: @izze, application: @app_2)
      @pet_app_4 = PetApplication.create!(pet: @boogie, application: @app_2)

      expect(@app_1.pets_length?).to eq(true)
      expect(@app_2.pets_length?).to eq(true)
      expect(@app_3.pets_length?).to eq(false)
    end
  end
end
