class Book < ApplicationRecord
  # Many-to-many associations (Feature 1.5 - many-to-many)
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors

  has_many :book_subjects, dependent: :destroy
  has_many :subjects, through: :book_subjects

  # One-to-many association (Feature 1.5 - one-to-many)
  has_many :reviews, dependent: :destroy

  # We'll add validations in next step
end