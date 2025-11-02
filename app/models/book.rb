class Book < ApplicationRecord
  # ... (associations from before)

  # Validations (Feature 1.6)
  validates :title, presence: true, length: { minimum: 1, maximum: 500 }
  validates :openlibrary_key, presence: true, uniqueness: true
  validates :first_publish_year, numericality: {
    only_integer: true,
    greater_than: 1000,
    less_than_or_equal_to: 2030,
    allow_nil: true
  }
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    allow_nil: true
  }, if: -> { rating.present? }

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