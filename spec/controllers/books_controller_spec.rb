require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }

  describe 'signed in users' do
    before { sign_in_as user }

    context 'books' do
      it 'shows a list of the existing books' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
