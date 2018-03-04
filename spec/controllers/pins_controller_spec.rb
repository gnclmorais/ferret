require 'rails_helper'

RSpec.describe PinsController, type: :controller do
  let(:user) { create(:user) }
  let!(:map) { create(:map) }
  let!(:place) { create(:place) }

  describe 'Logged in users' do
    context 'can create new pins' do
      before { sign_in_as user }

      it 'creates a new pin on an existing map' do
        expect do
          post :create, params: {
            map: map.id,
            place: {
              name: place.name,
              formatted_address: place.address,
              place_id: place.google_place_id
            },
            format: :json
          }
        end.to(change { Pin.count })

        expect(response).to have_http_status(:success)
      end

      it 'does not create a new place if already exists' do
        expect do
          post :create, params: {
            map: map.id,
            place: {
              name: place.name,
              formatted_address: place.address,
              place_id: place.google_place_id
            },
            format: :json
          }
        end.to_not(change { Place.count })

        expect(response).to have_http_status(:success)
      end

      it 'creates a new place when it doesn’t exist yet' do
        expect do
          post :create, params: {
            map: map.id,
            place: {
              name: 'Place Name',
              formatted_address: 'Formatted Address',
              place_id: '1234567890'
            },
            format: :json
          }
        end.to(change { Place.count })

        expect(response).to have_http_status(:success)
      end
    end

    context 'can destroy existing pins' do
      before do
        sign_in_as user
        @pin = create(:pin)
      end

      it 'destroys a pin on an existing map' do
        expect do
          delete :destroy, params: { id: @pin.id, format: :json }
        end.to(change { Pin.count })

        expect(response).to have_http_status(:success)
      end

      it 'destroys a place if no other pin references it' do
        expect do
          delete :destroy, params: { id: @pin.id, format: :json }
        end.to(change { Place.count })

        expect(response).to have_http_status(:success)
      end

      it 'does not destroys a place if other pins reference it' do
        another_pin = create(:pin, place: @pin.place)

        expect do
          delete :destroy, params: { id: another_pin.id, format: :json }
        end.to_not(change { Place.count })

        expect(response).to have_http_status(:success)
      end
    end
  end
end
