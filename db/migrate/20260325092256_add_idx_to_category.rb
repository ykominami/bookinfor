class AddIdxToCategory < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :idx, :integer
  end
end
