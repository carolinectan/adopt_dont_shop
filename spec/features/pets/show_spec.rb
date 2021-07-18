require 'rails_helper'

RSpec.describe 'the shelter show' do
  before :each do
    @shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    @pet1 = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @pet2 = Pet.create(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)

  end

  it "shows the shelter and all it's attributes" do

    visit "/pets/#{@pet1.id}"

    expect(page).to have_content(@pet1.name)
    expect(page).to have_content(@pet1.age)
    expect(page).to have_content(@pet1.adoptable)
    expect(page).to have_content(@pet1.breed)
    expect(page).to have_content(@pet1.shelter_name)
  end

  it "allows the user to delete a pet" do
    visit "/pets/#{@pet2.id}"

    click_on("Delete #{@pet2.name}")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content("#{@pet2.name}")
  end
end
