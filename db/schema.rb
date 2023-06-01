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

ActiveRecord::Schema[7.0].define(version: 2023_05_30_143551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abcs", force: :cascade do |t|
    t.integer "zid", null: false
    t.string "s", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booklistlooses", force: :cascade do |t|
    t.integer "totalID"
    t.integer "xid"
    t.date "purchase_date"
    t.string "bookstore"
    t.string "title"
    t.string "asin"
    t.integer "read_status"
    t.integer "shape"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["totalID"], name: "index_booklistlooses_on_totalID"
    t.index ["xid"], name: "index_booklistlooses_on_xid"
  end

  create_table "booklists", force: :cascade do |t|
    t.integer "totalID", null: false
    t.integer "xid"
    t.date "purchase_date", null: false
    t.string "bookstore", null: false
    t.string "title", null: false
    t.string "asin"
    t.integer "read_status", null: false
    t.integer "shape", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["totalID"], name: "index_booklists_on_totalID", unique: true
    t.index ["xid"], name: "index_booklists_on_xid", unique: true
  end

  create_table "booklisttaights", force: :cascade do |t|
    t.integer "totalID"
    t.integer "xid"
    t.date "purchase_date"
    t.string "bookstore"
    t.string "title"
    t.string "asin"
    t.integer "read_status"
    t.integer "shape"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["totalID"], name: "index_booklisttaights_on_totalID", unique: true
    t.index ["xid"], name: "index_booklisttaights_on_xid", unique: true
  end

  create_table "booklisttights", force: :cascade do |t|
    t.integer "totalID"
    t.integer "xid"
    t.date "purchase_date"
    t.string "bookstore"
    t.string "title"
    t.string "asin"
    t.integer "read_status"
    t.integer "shape"
    t.string "category"
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
    t.datetime "timestamp", precision: nil, null: false
    t.datetime "pubdate", precision: nil, null: false
    t.string "publisher", null: false
    t.string "authors", null: false
    t.string "author_sort", null: false
    t.string "languages", null: false
    t.string "rating", null: false
    t.string "identifiers", null: false
    t.integer "read_status"
    t.string "category"
    t.index ["uuid"], name: "index_calibrelists_on_uuid", unique: true
    t.index ["xid"], name: "index_calibrelists_on_xid", unique: true
    t.index ["xxid"], name: "index_calibrelists_on_xxid", unique: true
    t.index ["zid"], name: "index_calibrelists_on_zid", unique: true
  end

  create_table "kindlelists", force: :cascade do |t|
    t.string "asin", null: false
    t.string "title", null: false
    t.string "publisher"
    t.string "author", null: false
    t.date "publish_date"
    t.date "purchase_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "read_status"
    t.string "category"
  end

  create_table "readinglists", force: :cascade do |t|
    t.date "register_date", null: false
    t.date "date", null: false
    t.string "title", null: false
    t.string "status", null: false
    t.string "shape", null: false
    t.string "isbn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
