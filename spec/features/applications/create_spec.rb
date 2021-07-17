require 'rails_helper'

RSpec.describe 'application new page' do
  before :each do
    brighter_days = Shelter.create!(name: 'Brighter Days Shelter', rank: 1, city: 'Boulder', foster_program: true)
    underdogs = Shelter.create!(name: 'Underdogs Shelter', rank: 2, city: 'Denver', foster_program: true)

    bosco = brighter_days.pets.create!(name: 'Bosco', adoptable: true, age: 8, breed: 'Springer Spaniel')
    lily = brighter_days.pets.create!(name: 'Lily', adoptable: true, age: 5, breed: 'German Shepard Boxer Mix')

    izze = underdogs.pets.create!(name: 'Izze', adoptable: true, age: 8, breed: 'Cocker Spaniel')
    zephyr = underdogs.pets.create!(name: 'Zephyr', adoptable: true, age: 8, breed: 'Malamute')
    ruger = underdogs.pets.create!(name: 'Ruger', adoptable: true, age: 8, breed: 'Husky Samoyed Mix')

    app_1 = Application.create!(name: 'Elliot O.', street: '5743 Squirrel Circle', city: 'Aspen', state: 'CO', zip_code: 81611, application_status: 'pending')
    app_2 = Application.create!(name: 'Sami P.', street: '1123 Arbor Lane', city: 'Chicago', state: 'IL', zip_code: 60007, application_status: 'approved')
    app_3 = Application.create!(name: 'Amanda M.', street: '883 Teller Court', city: 'Wheat Ridge', state: 'CO', zip_code: 80033, application_status: 'pending')
    app_4 = Application.create!(name: 'Brian F.', street: '9090 Veterans Street', city: 'Wells', state: 'ME', zip_code: 14090, application_status: 'in progress')
    app_5 = Application.create!(name: 'Jacob M.', street: '8439 Felines Court', city: 'Westminster', state: 'CO', zip_code: 80021, application_status: 'rejected')
    app_6 = Application.create!(name: 'Jacob P.', street: '953 Brewers Street', city: 'Austin', state: 'TX', zip_code: 78704, application_status: 'pending')

    PetApplication.create!(pet: bosco, application: app_1)
    PetApplication.create!(pet: lily, application: app_1)
    PetApplication.create!(pet: izze, application: app_1)
    PetApplication.create!(pet: zephyr, application: app_1)
    PetApplication.create!(pet: ruger, application: app_1)
  end

  describe 'new application' do
    it 'can link to the new application page' do
      visit '/pets'

      click_link("Start an Application")

      expect(current_path).to eq('/applications/new')
    end

    it 'links to a new application page with a form' do
      visit '/pets'

      click_link("Start an Application")

      expect(current_path).to eq('/applications/new')

      fill_in('name', with: 'Carina Sweet')
      fill_in('street', with: '897 Candy Lane')
      fill_in('city', with: 'Denver')
      fill_in('state', with: 'CO')
      fill_in('zip_code', with: '80202')
      fill_in('description', with: 'Coop needs more dog friends!')

      click_button('Submit')

      expect(current_path).to eq("/applications/#{Application.last.id}")

      expect(page).to have_content("#{Application.last.name}'s Application")
      expect(page).to have_content("Street: #{Application.last.street}")
      expect(page).to have_content("City: #{Application.last.city}")
      expect(page).to have_content("State: #{Application.last.state}")
      expect(page).to have_content("Zip Code: #{Application.last.zip_code}")
      expect(page).to have_content("Description: #{Application.last.description}")
      expect(page).to have_content("Application Status: #{Application.last.application_status}")
    end

    it 'will take the user back to the new applications page if the form is incomplete' do
      visit '/pets'

      click_link("Start an Application")

      expect(current_path).to eq('/applications/new')

      fill_in('name', with: 'Scott Borecki')
      fill_in('street', with: '5532')
      fill_in('state', with: 'CO')
      fill_in('zip_code', with: '80001')
      fill_in('description', with: 'Our cats want a dog friend!')

      click_button('Submit')

      expect(current_path).to eq("/applications/new")

      expect(page).to have_content("New Application")
      expect(page).to have_content("Name")
      expect(page).to have_content("Street")
      expect(page).to have_content("City")
      expect(page).to have_content("State")
      expect(page).to have_content("Zip Code")
      expect(page).to have_content("Description")
    end
    # Starting an Application, Form not Completed
    #
    # As a visitor
    # When I visit the new application page
    # And I fail to fill in any of the form fields
    # And I click submit
    # Then I am taken back to the new applications page
    # And I see a message that I must fill in those fields.

  end
end
