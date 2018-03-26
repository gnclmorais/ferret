class TaggedPinsController < ApplicationController
  def create
    tag_name, pin_id = tagged_pins_params.values_at(:tag_name, :pin_id)

    tag = Tag.find_or_create_by(name: tag_name)
    pin = Pin.find(pin_id)

    respond_to do |format|
      format.json do
        new_tagged_pin = TaggedPin.new(tag: tag, pin: pin)
        if new_tagged_pin.save
          render json: new_tagged_pin.to_json, status: 200
        else
          render json: { errors: new_tagged_pin.errors }, status: :conflict
        end
      end
    end
  end

  def destroy
    tagged_pin = TaggedPin.find(params[:id])

    respond_to do |format|
      format.json do
        if tagged_pin.destroy
          render json: {}, status: 200
        else
          render json: { errors: tagged_pin.errors }, status: :conflict
        end
      end
    end
  end

  private

  def tagged_pins_params
    params.require(:tagged_pin)
  end
end
