class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :book, null: false, foreign_key: true
      t.string :reviewer_name, null: false
      t.integer :rating, null: false
      t.text :comment
      t.date :review_date

      t.timestamps
    end

    add_index :reviews, :rating
  end
end