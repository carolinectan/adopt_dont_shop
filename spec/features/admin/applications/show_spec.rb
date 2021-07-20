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
    @app_2 = Application.create!(name: 'Sami Peterson', street: '1123 Arbor Lane', city: 'Chicago', state: 'IL', zip_code: 60007, application_status: 'Pending', description: 'Responsible care taker')

    @petapp_1 = PetApplication.create!(pet: @jasmine, application: @app_1)
    @petapp_2 = PetApplication.create!(pet: @clyde, application: @app_1)
    @petapp_3 = PetApplication.create!(pet: @finn, application: @app_1)
    @petapp_4 = PetApplication.create!(pet: @jasmine, application: @app_2)
    @petapp_5 = PetApplication.create!(pet: @clyde, application: @app_2)
    @petapp_6 = PetApplication.create!(pet: @finn, application: @app_2)
  end

  it 'can approve a pet for adoption' do
    visit ("/admin/applications/#{@app_1.id}")

    expect(page).to have_content(@jasmine.name)
    expect(page).to have_content(@clyde.name)
    expect(page).to have_content(@finn.name)

    click_button("Approve #{@jasmine.name}")

    expect(current_path).to eq("/admin/applications/#{@app_1.id}")
    expect(page).to have_content("Application for #{@jasmine.name} has been approved!")
    expect(page).to_not have_selector('input[type=button] [value="Approve #{@jasmine.name}"]')
  end

  it 'can reject a pet for adoption' do
    visit ("/admin/applications/#{@app_1.id}")

    click_button("Reject #{@finn.name}")

    expect(current_path).to eq("/admin/applications/#{@app_1.id}")
    expect(page).to have_content("Application for #{@finn.name} has been rejected.")
    expect(page).to_not have_selector('input[type=button] [value="Reject #{@finn.name}"]')
  end

  it 'can approve/reject a pet on one application and not affect other applications' do

  end
end
