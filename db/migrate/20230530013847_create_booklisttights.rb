class CreateBooklisttights < ActiveRecord::Migration[7.0]
  def change
    create_table :booklisttights do |t|
      t.integer :totalID
      t.integer :xid
      t.date :purchase_date
      t.string :bookstore
      t.string :title
      t.string :asin
      t.integer :read_status
      t.integer :shape
      t.string :category

      t.timestamps
    end
  end
end
