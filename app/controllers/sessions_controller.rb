class SessionsController < Clearance::SessionsController
  def url_after_create
    maps_path
  end

  def url_for_signed_in_users
    maps_path
  end
end
