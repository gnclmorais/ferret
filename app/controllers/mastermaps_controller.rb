class MastermapsController < ApplicationController
  def show
    @book = Book.includes(:pins).find(book_id)

    render layout: 'application_fullscreen'
  end

  private

  def book_id
    params.require(:book_id)
  end
end
