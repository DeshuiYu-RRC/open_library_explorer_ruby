class SubjectsController < ApplicationController
  # Feature 3.4 - Hierarchical Navigation (part 1)
  def index
    @subjects = Subject.left_joins(:books)
                       .select('subjects.*, COUNT(books.id) as books_count')
                       .group('subjects.id')
                       .order('books_count DESC, subjects.name ASC')
                       .page(params[:page])
                       .per(50)

    @total_subjects = Subject.count
  end

  # Feature 3.4 - Hierarchical Navigation (part 2)
  def show
    @subject = Subject.find(params[:id])
    @books = @subject.books
                     .includes(:authors)
                     .order(:title)
                     .page(params[:page])
                     .per(20)

    @total_books = @subject.books.count
  end
end