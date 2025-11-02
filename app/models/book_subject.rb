class BookSubject < ApplicationRecord
  belongs_to :book
  belongs_to :subject

  # Prevent duplicate associations
  validates :book_id, uniqueness: { scope: :subject_id }
end