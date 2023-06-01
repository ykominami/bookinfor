class AbcCol < ActiveRecord::Migration[7.0]
  def change
    add_index :abcs, :zid, unique: true
    add_index :abcs, :s, unique: true
  end
end
