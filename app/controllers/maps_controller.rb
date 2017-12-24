class MapsController < ApplicationController
  def index
    @maps = Map.all
  end

  def show
    @map = Map.find(params[:id])
  end

  def new
    @map = Map.new
  end

  def edit
    @map = Map.find(params[:id])

    render layout: "application_without_navbar"
  end

  def create
    @map = Map.new(map_params)

    if @map.save
      redirect_to @map
    else
      render 'new'
    end
  end

  def update
    @map = Map.find(params[:id])

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
    params.require(:map).permit(:name, :description)
  end
end
