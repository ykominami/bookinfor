class CreateBooklists < ActiveRecord::Migration[7.0]
  def change
    create_table :booklists do |t|
      t.integer :totalID, null: false, unique: true
      t.integer :xid, null: true
      t.date :purchase_date, null: false
      t.string :title, null: false
      t.string :asin, null: true
      # t.string :bookstore, null: false
      t.string :bookstore_id, null: false
      # t.integer :read_status, null: false
      t.integer :readstatus_id, null: false
      # t.integer :shape, null: false
      t.integer :shape_id, null: false
      # t.string :category, null: false
      t.integer :category_id, null: false

      t.timestamps
    end
  end
end
