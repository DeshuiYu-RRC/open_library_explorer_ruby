class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.text :bio
      t.string :birth_date
      t.string :death_date
      t.string :photo_url
      t.string :openlibrary_key, null: false

      t.timestamps
    end

    add_index :authors, :openlibrary_key, unique: true
    add_index :authors, :name
  end
end