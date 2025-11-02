class Review < ApplicationRecord
  # One-to-many: many reviews belong to one book
  belongs_to :book
end