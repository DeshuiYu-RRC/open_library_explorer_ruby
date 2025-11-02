class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :description
      t.integer :first_publish_year
      t.integer :cover_id
      t.string :cover_url
      t.string :openlibrary_key, null: false
      t.string :isbn
      t.integer :page_count

      t.timestamps
    end

    # Add indexes for better query performance
    add_index :books, :openlibrary_key, unique: true
    add_index :books, :title
  end
end