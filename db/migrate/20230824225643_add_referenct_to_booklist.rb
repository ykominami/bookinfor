class AddReferenctToBooklist < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklists, :bookstore, foreign_key: true
  end
end
