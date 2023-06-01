class AddIndexToBooklistloose < ActiveRecord::Migration[7.0]
  def change
    add_index :booklistlooses, :totalID, unique: false
    add_index :booklistlooses, :xid, unique: false
  end
end
