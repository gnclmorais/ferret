require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }

  describe 'Anonymous users' do
    context 'home page' do
      it 'has access' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'about page' do
      it 'has access' do
        get :about
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'Signed in users' do
    before { sign_in_as user }

    context 'home page' do
      it 'redirects them to /maps' do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
