class CreateBooklisttights < ActiveRecord::Migration[7.0]
  def change
    create_table :booklisttights do |t|
      t.integer :totalID
      t.integer :xid
      t.date :purchase_date
      t.string :title
      t.string :asin
      # t.string :bookstore
      t.integer :bookstore_id
      # t.integer :read_status
      t.integer :readstatus_id
      # t.integer :shape
      t.integer :shape_id
      # t.string :category
      t.string :category_id

      t.timestamps
    end
  end
end
