class MapsController < ApplicationController
  # TODO: Fix this :update thing, we need authentication
  #       Google 'javascript rails ActionController::InvalidAuthenticityToken
  #       (ActionController::InvalidAuthenticityToken)'
  before_action :require_login, except: %w[index show]

  def index
    @maps = signed_in? ? Map.all : Map.where(published: true)
  end

  def new
    @map = Map.new
  end

  def show
    @map = Map.with_tagged_places.find(params[:id])

    render layout: 'application_fullscreen'
  end

  def edit
    @map = Map.with_tagged_places.find(params[:id])

    render layout: 'application_fullscreen'
  end

  def create
    # TODO: Maybe find a better way to do this
    @map = Map.new(**map_params, owner: current_user)

    if @map.save
      redirect_to edit_map_path(@map)
    else
      render 'new'
    end
  end

  def update
    @map = Map.find(params[:id])

    # if params[:pins].size == @map.pins.size
    #   # TODO: Save new pin order
    # else
    #   # TODO: do something?
    # end

    if @map.update(map_params)
      redirect_to @map
    else
      render 'edit'
    end
  end

  def destroy
    @map = Map.find(params[:id])
    @map.destroy

    redirect_to maps_path
  end

  private

  def map_params
    params
      .require(:map).permit(:name, :description, :pins, :published)
      .to_h.symbolize_keys
  end
end
