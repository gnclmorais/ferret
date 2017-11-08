class PinsController < ApplicationController
  # TODO Fix this
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      pin = create_pin

      # TODO Improve this condition
      if pin.is_a?(ActiveRecord::Base) && pin.valid?
        format.json { render json: { pin: pin, place: pin.place }, status: 200 }
      else
        format.json do
          render json: { message: pin }, status: :unprocessable_entity
        end
      end
    end

    # TODO: Make sure we have the required data:
    #       > map ID
    #       > place details (Place ID, address, etc)
    #       Look for the place using it's place ID
    #       > If found, create only a Pin
    #       > Else, create a Place first, followed by a Pin
    #       Think about to add details to the recently created pins
    #       > Check how Fourquare does it
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

  def create_pin
    ActiveRecord::Base.transaction do
      map_id, place_details = pin_params.values_at(:map, :place)

      map = Map.find(map_id)

      formatted = format(place_details)

      place = Place.find_by(google_place_id: formatted[:google_place_id]) ||
              Place.create!(formatted)

      Pin.create!(map: map, place: place)
      #Pin.new(map: map, place: place)
    end
  rescue => e
    e.message
  end

  def format(place)
    {
      google_place_id: place[:place_id],
      name: place[:name],
      address: place[:formatted_address],
      # TODO: Check if description is really necessary
      description: place[:types].join(', ')
    }
  end

  def pin_params
    params.require(:map)
    params.require(:place)
    params
  end
end
