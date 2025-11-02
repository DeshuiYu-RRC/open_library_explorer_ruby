class AuthorsController < ApplicationController
  # Feature 3.4 - Hierarchical Navigation (part 1)
  def index
    @authors = Author.includes(:books)
                     .order(:name)
                     .page(params[:page])
                     .per(30)

    @total_authors = Author.count
  end

  # Feature 3.4 - Hierarchical Navigation (part 2)
  def show
    @author = Author.includes(books: :subjects).find(params[:id])
    @books = @author.books.order(:title).page(params[:page]).per(20)
  end
end