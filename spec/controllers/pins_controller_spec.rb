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

      it 'creates a new place when it doesn’t exist yet' do
      end

      it 'does not create a new place if already exists' do
      end
    end

    context 'can destroy existing pins' do
      before { sign_in_as user }

      it 'destroys a pin on an existing map' do
      end

      it 'destroys a place if no other pin references it' do
      end

      it 'does not destroy a place if any other pin references it' do
      end
    end
  end
end
