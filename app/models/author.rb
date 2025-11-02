class Author < ApplicationRecord
  # Many-to-many association with books
  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :openlibrary_key, presence: true, uniqueness: true
end