class Subject < ApplicationRecord
  # Many-to-many association with books
  has_many :book_subjects, dependent: :destroy
  has_many :books, through: :book_subjects
end