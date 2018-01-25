class PinsController < ApplicationController
  # TODO: Fix this
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      pin = ensure_pin

      format.json do
        if pin.valid?
          render json: pin.to_json, status: 200
        else
          render json: { errors: pin.errors }, status: :conflict
        end
      end
    end
  end

  def destroy
    id = params.fetch(:id, nil)
    pin = Pin.find(id)
    place = pin.place

    respond_to do |format|
      if pin.delete
        # TODO Send response
        format.json { head :no_content }

        place.delete if place.pins.empty?
      else
        # TODO Send response
        format.json do
          render json: { message: pin.errors }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def ensure_pin
    ActiveRecord::Base.transaction do
      map_id, place_details = pin_params.values_at(:map, :place)

      map = Map.find(map_id)
      place = Place.find_or_create_by(attributes(place_details))

      Pin.create(map: map, place: place)
    end
  end

  def attributes(place)
    {
      google_place_id: place[:place_id],
      name: place[:name],
      address: place[:address]
    }
  end

  def pin_params
    params.require(:map)
    params.require(:place).permit(:id, :place_id, :name, :address)
    params
  end
end
