class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.includes(:maps).find(params[:id])
  end
end
