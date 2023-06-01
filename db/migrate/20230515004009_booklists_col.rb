class BooklistsCol < ActiveRecord::Migration[7.0]
  def change
    add_index :booklists, :totalID, unique: true
    add_index :booklists, :xid, unique: true
  end
end
