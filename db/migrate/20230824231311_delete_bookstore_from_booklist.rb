class DeleteBookstoreFromBooklist < ActiveRecord::Migration[7.0]
  def change
    remove_column :booklists, :bookstore
  end
end
