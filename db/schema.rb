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

ActiveRecord::Schema[7.2].define(version: 2024_10_14_160612) do
  create_table "booklists", force: :cascade do |t|
    t.string "asin"
    t.integer "totalID", null: false
    t.integer "xid"
    t.date "purchase_date", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "readstatus_id"
    t.integer "bookstore_id"
    t.integer "shape_id"
    t.integer "category_id"
    t.index ["bookstore_id"], name: "index_booklists_on_bookstore_id"
    t.index ["category_id"], name: "index_booklists_on_category_id"
    t.index ["readstatus_id"], name: "index_booklists_on_readstatus_id"
    t.index ["shape_id"], name: "index_booklists_on_shape_id"
  end

  create_table "bookstores", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calibrelists", force: :cascade do |t|
    t.integer "xid", null: false
    t.string "xxid", null: false
    t.string "isbn"
    t.integer "zid", null: false
    t.string "uuid", null: false
    t.string "comments"
    t.integer "size"
    t.string "series"
    t.integer "series_index", null: false
    t.string "title", null: false
    t.string "title_sort", null: false
    t.string "tags"
    t.string "library_name", null: false
    t.string "formats", null: false
    t.datetime "timestamp", null: false
    t.datetime "pubdate", null: false
    t.string "publisher", null: false
    t.string "authors", null: false
    t.string "author_sort", null: false
    t.string "languages", null: false
    t.string "rating", null: false
    t.string "identifiers", null: false
    t.integer "readstatus_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_calibrelists_on_category_id"
    t.index ["readstatus_id"], name: "index_calibrelists_on_readstatus_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kindlelists", force: :cascade do |t|
    t.string "asin", null: false
    t.string "author", null: false
    t.string "title", null: false
    t.string "publisher"
    t.date "publish_date"
    t.date "purchase_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "readstatus_id"
    t.integer "shape_id"
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_kindlelists_on_category_id"
    t.index ["readstatus_id"], name: "index_kindlelists_on_readstatus_id"
    t.index ["shape_id"], name: "index_kindlelists_on_shape_id"
  end

  create_table "readinglists", force: :cascade do |t|
    t.date "register_date", null: false
    t.date "date", null: false
    t.string "title", null: false
    t.string "isbn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shape_id"
    t.integer "readingstatus_id"
    t.index ["readingstatus_id"], name: "index_readinglists_on_readingstatus_id"
    t.index ["shape_id"], name: "index_readinglists_on_shape_id"
  end

  create_table "readingstatuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "readstatuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shapes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "booklists", "bookstores"
  add_foreign_key "booklists", "categories"
  add_foreign_key "booklists", "readstatuses"
  add_foreign_key "booklists", "shapes"
  add_foreign_key "calibrelists", "categories"
  add_foreign_key "calibrelists", "readstatuses"
  add_foreign_key "kindlelists", "categories"
  add_foreign_key "kindlelists", "readstatuses"
  add_foreign_key "kindlelists", "shapes"
  add_foreign_key "readinglists", "readingstatuses"
  add_foreign_key "readinglists", "shapes"
end
