class UsersController < Clearance::UsersController
  def url_after_create
    maps_path
  end
end
