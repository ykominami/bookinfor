class AddBookstoreIdToBooklists < ActiveRecord::Migration[7.2]
  def change
    add_reference :booklists, :bookstore, foreign_key: true
    change_column :booklists, :bookstore_id, :integer, null: true
  end
end
