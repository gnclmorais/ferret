require 'rails_helper'

RSpec.describe MapsController, type: :controller do
  let(:user) { create(:user) }
  let(:map) { create(:map) }

  describe 'Anonymous users' do
    context 'have read access' do
      it 'shows the list of maps' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'shows a single map' do
        get :show, params: { id: map }
        expect(response).to have_http_status(:success)
      end
    end

    context 'do not have write access' do
      it 'does not show a new map page' do
        get :new
        expect(response).to have_http_status(:redirect)
      end

      it 'does not edit an existing map' do
        get :edit, params: { id: map }
        expect(response).to have_http_status(:redirect)
      end

      it 'does not create a new map' do
        expect do
          post :create, params: {
            map: { name: 'Name', description: 'Description' }
          }
        end.to_not(change { Map.count })
        expect(response).to have_http_status(:redirect)
      end

      it 'does not update an existing map' do
        patch :update, params: { id: map, map: { name: 'New Name' } }
        expect(map.reload.name).to_not eq('New Name')
      end

      it 'does not destroy an existing map' do
        delete :destroy, params: { id: map }
        expect { Map.find(map.id) }.to_not raise_error
      end
    end
  end

  describe 'Logged in users' do
    context 'have read access' do
      it 'shows the list of maps' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'shows a single map' do
        get :show, params: { id: map }
        expect(response).to have_http_status(:success)
      end
    end

    context 'have write access' do
      before { sign_in_as user }

      it 'loads the page for a new map' do
        get :new
        expect(response).to have_http_status(:success)
      end

      it 'edits an existing map' do
        get :edit, params: { id: map }
        expect(response).to have_http_status(:success)
      end

      it 'creates a new map' do
        expect do
          post :create, params: {
            map: { name: 'Name', description: 'Description' }
          }
        end.to(change { Map.count })
      end

      it 'updates an existing map' do
        patch :update, params: { id: map, map: { name: 'New Name' } }
        expect(map.reload.name).to eq('New Name')
      end

      it 'destroys an existing map' do
        delete :destroy, params: { id: map }
        expect { Map.find(map.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
