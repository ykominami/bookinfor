class AddIdxToShapes < ActiveRecord::Migration[8.1]
  def change
    add_column :shapes, :idx, :integer
  end
end
