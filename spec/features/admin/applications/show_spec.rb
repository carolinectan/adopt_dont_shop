require 'rails_helper'

RSpec.describe 'the admin shelters show page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV Animal Shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy Pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'Tuxedo Shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'Shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'Sphynx', age: 8, adoptable: true)

    @jasmine = @shelter_1.pets.create!(name: 'Jasmine', adoptable: true, age: 8, breed: 'Black Lab')
    @clyde = @shelter_3.pets.create!(name: 'Clyde', adoptable: true, age: 8, breed: 'Boxer')
    @finn = @shelter_2.pets.create!(name: 'Finn', adoptable: true, age: 8, breed: 'Australian Shepard')

    @app_1 = Application.create!(name: 'Jacob Piland', street: '953 Brewers Street', city: 'Austin', state: 'TX', zip_code: 78704, application_status: 'Pending', description: 'Dog friendly family home with big yard')
    # @app_2 = Application.create!(name: 'Sami Peterson', street: '1123 Arbor Lane', city: 'Chicago', state: 'IL', zip_code: 60007, application_status: 'Approved', description: 'Responsible care taker')
    # @app_3 = Application.create!(name: 'Brian Fletcher', street: '9090 Veterans Street', city: 'Wells', state: 'ME', zip_code: 14090, application_status: 'In Progress', description: 'Adventure loving family')

    @petapp_1 = PetApplication.create!(pet: @jasmine, application: @app_1)
    @petapp_2 = PetApplication.create!(pet: @clyde, application: @app_1)
    @petapp_3 = PetApplication.create!(pet: @finn, application: @app_1)
  end

  it 'can approve a pet for adoption' do
    visit ("/admin/applications/#{@app_1.id}")

    expect(page).to have_content(@jasmine.name)
    expect(page).to have_content(@clyde.name)
    expect(page).to have_content(@finn.name)
  end
end

# For every pet that the application is for, I see a button to approve the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved
