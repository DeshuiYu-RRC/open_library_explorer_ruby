class BookAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author

  # Prevent duplicate associations
  validates :book_id, uniqueness: { scope: :author_id }
end