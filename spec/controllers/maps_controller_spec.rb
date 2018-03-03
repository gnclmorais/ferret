require 'rails_helper'

RSpec.describe MapsController, type: :controller do
  let(:user) { create(:user) }
  let(:map) { create(:map) }

  context 'Anonymous users' do
    it '#index is successful' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '#show is successful' do
      get :show, params: { id: map }
      expect(response).to have_http_status(:success)
    end
  end

  context 'Logged in users' do
    before { sign_in_as user }

    it '#index is successful' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '#show is successful' do
      get :show, params: { id: map }
      expect(response).to have_http_status(:success)
    end

    it '#new is successful' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '#edit is successful' do
      get :edit, params: { id: map }
      expect(response).to have_http_status(:success)
    end

    it '#create is successful' do
      expect do
        post :create, params: {
          id: map,
          map: { name: 'Name', description: 'Description' }
        }
      end.to(change { Map.count })
    end

    it '#update is successful' do
      patch :update, params: { id: map, map: { name: 'New Name' } }
      expect(map.reload.name).to eq('New Name')
    end

    it '#destroy is successful' do
      delete :destroy, params: { id: map }
      expect { Map.find(map.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
