class HomeController < ApplicationController
  before_action :skip_homepage, only: %w[index]

  def index; end

  private

  def skip_homepage
    redirect_to maps_path if signed_in?
  end
end
