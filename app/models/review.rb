class Review < ApplicationRecord
  # One-to-many: many reviews belong to one book
  belongs_to :book

  validates :reviewer_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :rating, presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5
            }
  validates :comment, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :review_date, presence: true
end