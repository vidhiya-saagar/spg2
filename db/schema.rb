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

ActiveRecord::Schema[7.0].define(version: 2023_04_14_160208) do
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
    t.integer "sequence", null: false
    t.index ["chapter_id", "sequence"], name: "index_chhands_on_chapter_id_and_sequence", unique: true
    t.index ["chapter_id"], name: "index_chhands_on_chapter_id"
    t.index ["chhand_type_id"], name: "index_chhands_on_chhand_type_id"
  end

  create_table "external_pauris", force: :cascade do |t|
    t.integer "pauri_id", null: false
    t.text "content", null: false
    t.text "original_content"
    t.text "bhai_vir_singh_footnote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pauri_id"], name: "index_external_pauris_on_pauri_id"
  end

  create_table "pauri_translations", force: :cascade do |t|
    t.string "en_translation"
    t.string "en_translator"
    t.integer "pauri_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pauri_id"], name: "index_pauri_translations_on_pauri_id"
  end

  create_table "pauris", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "chapter_id", null: false
    t.integer "chhand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_pauris_on_chapter_id"
    t.index ["chhand_id"], name: "index_pauris_on_chhand_id"
    t.index ["number", "chapter_id"], name: "index_pauris_on_number_and_chapter_id", unique: true
  end

  create_table "tuk_footnotes", force: :cascade do |t|
    t.integer "tuk_id", null: false
    t.text "bhai_vir_singh_footnote"
    t.string "contentful_entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contentful_entry_id"], name: "index_tuk_footnotes_on_contentful_entry_id", unique: true
    t.index ["tuk_id"], name: "index_tuk_footnotes_on_tuk_id"
  end

  create_table "tuk_translations", force: :cascade do |t|
    t.integer "tuk_id", null: false
    t.string "en_translation"
    t.string "en_translator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tuk_id"], name: "index_tuk_translations_on_tuk_id"
  end

  create_table "tuks", force: :cascade do |t|
    t.integer "chapter_id", null: false
    t.integer "pauri_id", null: false
    t.integer "sequence", null: false
    t.string "content", null: false
    t.string "original_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_tuks_on_chapter_id"
    t.index ["pauri_id"], name: "index_tuks_on_pauri_id"
    t.index ["sequence", "pauri_id"], name: "index_tuks_on_sequence_and_pauri_id", unique: true
  end

  add_foreign_key "chapters", "books"
  add_foreign_key "chhands", "chapters"
  add_foreign_key "chhands", "chhand_types"
  add_foreign_key "external_pauris", "pauris"
  add_foreign_key "pauri_translations", "pauris"
  add_foreign_key "pauris", "chapters"
  add_foreign_key "pauris", "chhands"
  add_foreign_key "tuk_footnotes", "tuks"
  add_foreign_key "tuk_translations", "tuks"
  add_foreign_key "tuks", "chapters"
  add_foreign_key "tuks", "pauris"
end
