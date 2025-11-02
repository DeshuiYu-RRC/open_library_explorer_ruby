class Author < ApplicationRecord
  # Many-to-many association with books
  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors
end