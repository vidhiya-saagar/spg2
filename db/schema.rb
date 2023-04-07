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

ActiveRecord::Schema[7.0].define(version: 2023_04_07_102145) do
  create_table "books", force: :cascade do |t|
    t.integer "sequence", null: false
    t.string "title", null: false
    t.string "en_title"
    t.string "en_short_summary"
    t.text "en_synopsis"
    t.text "artwork_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "number", null: false
    t.string "title", null: false
    t.string "en_title"
    t.string "en_short_summary"
    t.text "en_long_summary"
    t.string "samapati"
    t.string "en_samapati"
    t.text "artwork_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "number"], name: "index_chapters_on_book_id_and_number", unique: true
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "chhand_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "en_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_chhand_types_on_name", unique: true
  end

  create_table "chhands", force: :cascade do |t|
    t.integer "chapter_id", null: false
    t.integer "chhand_type_id", null: false
    t.string "vaak"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_chhands_on_chapter_id"
    t.index ["chhand_type_id"], name: "index_chhands_on_chhand_type_id"
  end

  add_foreign_key "chapters", "books"
  add_foreign_key "chhands", "chapters"
  add_foreign_key "chhands", "chhand_types"
end
