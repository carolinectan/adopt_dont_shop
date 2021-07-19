class AdminSheltersController < ApplicationController
  def index
    @admin_shelters = Shelter.find_by_sql("SELECT * FROM Shelters ORDER BY shelters.name DESC")
  end
end
