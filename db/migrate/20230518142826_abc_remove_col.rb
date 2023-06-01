class AbcRemoveCol < ActiveRecord::Migration[7.0]
  def change
    remove_index :abcs, :zid
    remove_index :abcs, :s
  end
end
