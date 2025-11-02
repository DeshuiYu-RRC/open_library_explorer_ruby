# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_02_185021) do
  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.text "bio"
    t.string "birth_date"
    t.string "death_date"
    t.string "photo_url"
    t.string "openlibrary_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authors_on_name"
    t.index ["openlibrary_key"], name: "index_authors_on_openlibrary_key", unique: true
  end

  create_table "book_authors", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_book_authors_on_author_id"
    t.index ["book_id"], name: "index_book_authors_on_book_id"
  end

  create_table "book_subjects", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_subjects_on_book_id"
    t.index ["subject_id"], name: "index_book_subjects_on_subject_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "first_publish_year"
    t.integer "cover_id"
    t.string "cover_url"
    t.string "openlibrary_key", null: false
    t.string "isbn"
    t.integer "page_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openlibrary_key"], name: "index_books_on_openlibrary_key", unique: true
    t.index ["title"], name: "index_books_on_title"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "book_id", null: false
    t.string "reviewer_name", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.date "review_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["rating"], name: "index_reviews_on_rating"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  add_foreign_key "book_authors", "authors"
  add_foreign_key "book_authors", "books"
  add_foreign_key "book_subjects", "books"
  add_foreign_key "book_subjects", "subjects"
  add_foreign_key "reviews", "books"
end
