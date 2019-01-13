require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:file) {
    fixture_file_upload Rails.root.join('spec', 'resources', 'book_cover.jpg')
  }

  describe 'signed in users' do
    before { sign_in_as user }

    context 'books' do
      it 'shows a list of the existing books' do
        create(:book)
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'edits an existing book' do
        get :edit, params: { id: book }
        expect(response).to have_http_status(:success)
      end

      it 'updates an existing book' do
        patch :update, params: { id: book, book: { name: 'Cogito' } }
        expect(book.reload.name).to eq('Cogito')
      end

      it 'uploads a cover to an existing book' do
        expect(book.cover.attached?).to be false
        patch :update, params: { id: book, book: { cover: file } }
        expect(book.reload.cover.attached?).to be true
      end
    end
  end
end
