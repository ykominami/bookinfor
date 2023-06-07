class RemoveIndexToBooklist < ActiveRecord::Migration[7.0]
  def change
    remove_index :booklistlooses, column: :xid
  end
end
