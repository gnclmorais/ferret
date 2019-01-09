class BooksController < ApplicationController
  def index
    @books = Book.with_attached_cover.all
  end

  def show
    @book = Book.includes(:maps).find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update!(book_params)
      redirect_to @book
    else
      render 'edit'
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :cover)
  end
end
