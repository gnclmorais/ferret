class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :google_maps_api_key

  private

  def google_maps_api_key
    gon.google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
  end
end
