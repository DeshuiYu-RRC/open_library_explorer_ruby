class BooksController < ApplicationController
  # Feature 3.1 - Collection Navigation
  def index
    @books = Book.includes(:authors)
                 .order(:title)
                 .page(params[:page])
                 .per(20)

    @total_books = Book.count
  end

  # Feature 3.2 - Member Pages
  # Feature 3.3 - Multi-model Data on Member Pages
  def show
    @book = Book.includes(:authors, :subjects, :reviews)
                .find(params[:id])

    @related_books = Book.joins(:book_subjects)
                         .where(book_subjects: { subject_id: @book.subject_ids })
                         .where.not(id: @book.id)
                         .distinct
                         .limit(6)
  end

  # Feature 4.1 - Simple Search
  def search
    @query = params[:query]

    if @query.present?
      @books = Book.where("title LIKE ? OR description LIKE ?",
                          "%#{@query}%", "%#{@query}%")
                   .includes(:authors)
                   .order(:title)
                   .page(params[:page])
                   .per(20)

      @total_results = @books.total_count
    else
      @books = Book.none.page(params[:page])
      @total_results = 0
    end

    render :index
  end
end