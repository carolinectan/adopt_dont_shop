require 'rails_helper'

RSpec.describe 'the admin shelters show page' do
  before(:each) do
    PetApplication.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all

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

  describe 'it can approve or reject a pet' do
    it 'can approve a pet for adoption' do
      visit ("/admin/applications/#{@app_1.id}")

      expect(page).to have_content(@jasmine.name)
      expect(page).to have_content(@clyde.name)
      expect(page).to have_content(@finn.name)

      click_button("Approve #{@jasmine.name}")

      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      expect(page).to have_content("Application for #{@jasmine.name} has been approved!")
      expect(page).to_not have_button("Approve #{@jasmine.name}")
    end

    it 'can reject a pet for adoption' do
      visit ("/admin/applications/#{@app_1.id}")

      click_button("Reject #{@finn.name}")

      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      expect(page).to have_content("Application for #{@finn.name} has been rejected.")
      expect(page).to_not have_button("Reject #{@finn.name}")
    end

    it 'can approve a pet on one application and not affect other applications' do
      visit ("/admin/applications/#{@app_1.id}")

      click_button("Approve #{@finn.name}")
      expect(page).to have_content("Application for #{@finn.name} has been approved!")
      expect(page).to_not have_button("Approve #{@finn.name}")

      visit ("/admin/applications/#{@app_2.id}")
      expect(page).to_not have_content("Application for #{@finn.name} has been approved!")
      expect(page).to have_button("Approve #{@finn.name}")
      expect(page).to have_button("Reject #{@finn.name}")
    end

    it 'can reject a pet on one application and not affect other applications' do
      visit ("/admin/applications/#{@app_1.id}")

      click_button("Reject #{@finn.name}")
      expect(page).to have_content("Application for #{@finn.name} has been rejected.")
      expect(page).to_not have_button("Reject #{@finn.name}")

      visit ("/admin/applications/#{@app_2.id}")

      expect(page).to_not have_content("Application for #{@finn.name} has been rejected.")
      expect(page).to have_button("Reject #{@finn.name}")
      expect(page).to have_button("Approve #{@finn.name}")
    end
  end

  describe 'a completed application' do
    it 'can approve all pets on an application and change application status to approved' do
      visit ("/admin/applications/#{@app_1.id}")

      click_button("Approve #{@finn.name}")
      click_button("Approve #{@jasmine.name}")
      click_button("Approve #{@clyde.name}")

      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      expect(page).to have_content("Application Status: Approved")
    end

    it 'can reject one or more pets and approve all other pets and change application status to rejected' do
      visit ("/admin/applications/#{@app_1.id}")

      click_button("Approve #{@finn.name}")
      click_button("Reject #{@jasmine.name}")
      click_button("Approve #{@clyde.name}")

      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      expect(page).to have_content("Application Status: Rejected")

      visit ("/admin/applications/#{@app_2.id}")

      click_button("Reject #{@finn.name}")
      click_button("Reject #{@jasmine.name}")
      click_button("Approve #{@clyde.name}")

      expect(current_path).to eq("/admin/applications/#{@app_2.id}")
      expect(page).to have_content("Application Status: Rejected")
    end

    it 'can approve an application and make those pets not adoptable' do
      visit("/pets/#{@finn.id}")
      expect(page).to have_content("Adoptable: true\nShelter")

      visit("/pets/#{@jasmine.id}")
      expect(page).to have_content("Adoptable: true\nShelter")

      visit("/pets/#{@clyde.id}")
      expect(page).to have_content("Adoptable: true\nShelter")


      visit ("/admin/applications/#{@app_1.id}")

      click_button("Approve #{@finn.name}")
      click_button("Approve #{@jasmine.name}")
      click_button("Approve #{@clyde.name}")

      visit("/pets/#{@finn.id}")
      expect(page).to have_content("Adoptable: false ; #{@finn.name} is no longer adoptable.")

      visit("/pets/#{@jasmine.id}")
      expect(page).to have_content("Adoptable: false ; #{@jasmine.name} is no longer adoptable.")

      visit("/pets/#{@clyde.id}")
      expect(page).to have_content("Adoptable: false ; #{@clyde.name} is no longer adoptable.")
    end

    xit 'can have pets only have one approved application on them at any time' do
      visit ("/admin/applications/#{@app_1.id}")
      # save_and_open_page

      # When a pet has an "Approved" application on them
      click_button("Approve #{@finn.name}")
      click_button("Approve #{@jasmine.name}")
      click_button("Approve #{@clyde.name}")

      # save_and_open_page
      visit ("/admin/applications/#{@app_2.id}")
      # And when the pet has a "Pending" application on them
      # And I visit the admin application show page for the pending application
      # save_and_open_page

      expect(page).to_not have_button("Approve #{@finn.name}")
      # Then next to the pet I do not see a button to approve them
      # And instead I see a message that this pet has been approved for adoption
      expect(page).to have_content("#{@clyde.name} has been approved for adoption.")

      # And I do see a button to reject them
      expect(page).to have_button("Reject #{@finn.name}")
    end
  end
end
