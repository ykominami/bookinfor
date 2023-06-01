class CalibrelistsCol < ActiveRecord::Migration[7.0]
  def change
    add_index :calibrelists, :xid, unique: true
    add_index :calibrelists, :xxid, unique: true
    add_index :calibrelists, :zid, unique: true
    add_index :calibrelists, :uuid, unique: true
  end
end
