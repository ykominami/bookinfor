class AddIndexToBooklisttaight < ActiveRecord::Migration[7.0]
  def change
    add_index :booklisttaights, :totalID, unique: true
    add_index :booklisttaights, :xid, unique: true
  end
end
