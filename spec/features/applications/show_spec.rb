require 'rails_helper'

RSpec.describe 'the applications show page' do
  before :each do
    @brighter_days = Shelter.create!(name: 'Brighter Days Shelter', rank: 1, city: 'Boulder', foster_program: true)
    @underdogs = Shelter.create!(name: 'Underdogs Shelter', rank: 2, city: 'Denver', foster_program: true)

    @bosco = @brighter_days.pets.create!(name: 'Bosco', adoptable: true, age: 8, breed: 'Springer Spaniel')
    @lily = @brighter_days.pets.create!(name: 'Lily', adoptable: true, age: 5, breed: 'German Shepard Boxer Mix')
    @izze = @underdogs.pets.create!(name: 'Izze', adoptable: true, age: 8, breed: 'Cocker Spaniel')
    @boogie = @underdogs.pets.create!(name: 'Boogie', adoptable: true, age: 12, breed: 'Husky Samoyed Mix')

    @app_1 = Application.create!(name: 'Elliot O.', street: '5743 Squirrel Circle', city: 'Aspen', state: 'CO', zip_code: 81611, application_status: 'Pending', description: 'loves animals')
    @app_2 = Application.create!(name: 'Sami P.', street: '1123 Arbor Lane', city: 'Chicago', state: 'IL', zip_code: 60007, application_status: 'Approved', description: 'loving home')
    @app_3 = Application.create!(name: 'Amanda M.', street: '883 Teller Court', city: 'Wheat Ridge', state: 'CO', zip_code: 80033, application_status: 'In Progress')

    @pet_app_1 = PetApplication.create!(pet: @bosco, application: @app_1)
    @pet_app_2 = PetApplication.create!(pet: @lily, application: @app_1)
    @pet_app_3 = PetApplication.create!(pet: @izze, application: @app_2)
    @pet_app_4 = PetApplication.create!(pet: @boogie, application: @app_2)
  end

  describe 'display attributes of an application' do
    it 'can display the name, full address, description, pet(s) applied for, and status of the application' do
      visit "/applications/#{@app_1.id}"

      expect(page).to have_content("#{@app_1.name}'s Application")
      expect(page).to have_content("Street: #{@app_1.street}")
      expect(page).to have_content("City: #{@app_1.city}")
      expect(page).to have_content("State: #{@app_1.state}")
      expect(page).to have_content("Zip Code: #{@app_1.zip_code}")
      expect(page).to have_content("Why I Would Make a Good Owner: #{@app_1.description}")
      expect(page).to have_content("Pet(s) Applied For: #{@pet_app_1.pet.name} , #{@pet_app_2.pet.name}")
      expect(page).to have_content("Application Status: #{@app_1.application_status}")
    end

    it 'can link to each pets show page in the pets applied for section' do
      visit "/applications/#{@app_1.id}"

      click_link("Bosco")

      expect(current_path).to eq("/pets/#{@bosco.id}")

      visit "/applications/#{@app_1.id}"

      click_link("Lily")

      expect(current_path).to eq("/pets/#{@lily.id}")
    end
  end

  describe 'add a pet to an application' do
    it 'can search for pets to add to an unsubmitted application' do
      visit "/applications/#{@app_3.id}"

      expect(page).to have_content('Add a Pet to this Application')

      fill_in :search, with: 'Lily'
      click_button 'Search'

      expect(current_path).to eq("/applications/#{@app_3.id}")
      expect(page).to have_content('Lily')
    end

    it 'can add a pet to an application' do
      visit "/applications/#{@app_3.id}"

      expect(page).to_not have_content('Lily')
      expect(page).to_not have_content('Submit My Application')

      fill_in :search, with: 'Lily'
      click_button 'Search'

      expect(current_path).to eq("/applications/#{@app_3.id}")
      expect(page).to have_content('Lily')

      click_button "Adopt #{@lily.name}"

      expect(current_path).to eq("/applications/#{@app_3.id}")
      expect(page).to have_content("Pet(s) Applied For: #{@lily.name}")
    end

    it 'can submit an application' do
      visit "/applications/#{@app_3.id}"

      fill_in :search, with: 'Lily'
      click_button 'Search'

      expect(current_path).to eq("/applications/#{@app_3.id}")
      expect(page).to have_content('Lily')

      click_button "Adopt #{@lily.name}"

      expect(current_path).to eq("/applications/#{@app_3.id}")
      expect(page).to have_content("Pet(s) Applied For: #{@lily.name}")


      expect(page).to have_content("Submit My Application")

      fill_in :description, with: 'I like dogs!'
      click_button 'Submit'

      expect(current_path).to eq("/applications/#{@app_3.id}")
      expect(page).to have_content("Application Status: #{@app_1.application_status}")
      expect(page).to have_content("Application Status: Pending")
      expect(page).to have_content('Lily')

      expect(page).to_not have_content('Add a Pet to this Application')
      expect(page).to_not have_content('Submit My Application')
    end
  end

  describe 'database logic part 1' do
    it 'lists partial matches for pet names' do
      visit "/applications/#{@app_3.id}"

      fill_in :search, with: "Bo"
      click_button 'Search'

      expect(page).to have_content(@bosco.name)
      expect(page).to have_content(@boogie.name)
      expect(page).to_not have_content(@izze.name)
      expect(page).to_not have_content(@lily.name)
    end

    it 'lists case insensitive matches for pet names' do
      visit "/applications/#{@app_3.id}"

      fill_in :search, with: "BoScO"
      click_button 'Search'

      expect(page).to have_content(@bosco.name)
      expect(page).to_not have_content(@boogie.name)
      expect(page).to_not have_content(@izze.name)
      expect(page).to_not have_content(@lily.name)

      visit "/applications/#{@app_3.id}"

      fill_in :search, with: "lILY"
      click_button 'Search'

      expect(page).to have_content(@lily.name)
      expect(page).to_not have_content(@bosco.name)
      expect(page).to_not have_content(@boogie.name)
      expect(page).to_not have_content(@izze.name)
    end
  end
end
