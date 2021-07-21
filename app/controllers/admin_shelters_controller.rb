class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM Shelters ORDER BY shelters.name DESC")

    @shelters_pending_apps = Shelter.has_pending_apps
    # just call this .has_pending_apps method in the view, don't make another instance variable just use the @shelters instance variable
  end
end
