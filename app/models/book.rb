class Book < ApplicationRecord
  # Many-to-many associations
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors

  has_many :book_subjects, dependent: :destroy
  has_many :subjects, through: :book_subjects

  # One-to-many association
  has_many :reviews, dependent: :destroy

  # Validations (Feature 1.6)
  validates :title, presence: true, length: { minimum: 1, maximum: 500 }
  validates :openlibrary_key, presence: true, uniqueness: true
  validates :first_publish_year, numericality: {
    only_integer: true,
    greater_than: 1000,
    less_than_or_equal_to: 2030,
    allow_nil: true
  }

  # Helper method for cover image URL
  def cover_image_url(size = 'M')
    if cover_id.present?
      "https://covers.openlibrary.org/b/id/#{cover_id}-#{size}.jpg"
    else
      "https://via.placeholder.com/300x450?text=No+Cover"
    end
  end

  # Average rating calculation
  def average_rating
    return 0 if reviews.empty?
    (reviews.average(:rating) || 0).round(1)
  end
end