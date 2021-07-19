class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM Shelters ORDER BY shelters.name DESC")

    @shelters_pending_apps = Shelter.has_pending_apps
  end
end
