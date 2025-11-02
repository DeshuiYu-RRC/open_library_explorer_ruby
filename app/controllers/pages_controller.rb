class PagesController < ApplicationController
  # Feature 2.1 - About Page
  def about
    @total_books = Book.count
    @total_authors = Author.count
    @total_subjects = Subject.count
    @total_reviews = Review.count
  end
end