class PinsController < ApplicationController
  # TODO: Fix this
  skip_before_action :verify_authenticity_token

  def update
    id, newName = update_pin_params[:pin].values_at(:id, :name)

    pin = Pin.find(id)
    pin.update(name: newName)

    respond_to do |format|
      format.json do
        if pin.save
          head :ok
        else
          render json: { errors: pin.errors }, status: :conflict
        end
      end
    end
  end

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
    pin = pin_from_params
    place = pin.place

    respond_to do |format|
      format.json do
        if pin.delete
          place.delete if place.pins.empty?
          head :no_content
        else
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
      return if map.blank?

      place = Place.find_or_create_by(attributes(place_details))

      Pin.create(map_id: map.id, place_id: place.id)
    end
    # TODO: Try with invalid inputs
  end

  def attributes(place)
    {
      name: place[:name],
      address: place[:formatted_address],
      google_place_id: place[:place_id]
    }
  end

  def pin_from_params
    Pin.find(params.fetch(:id, nil))
  end

  def pin_params
    params.require(:map)
    params.require(:place).permit(:id, :place_id, :name, :address)
    params
  end

  def update_pin_params
    params.require(:pin).permit(:id, :name)
    params
  end
end
