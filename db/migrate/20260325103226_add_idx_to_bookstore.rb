class AddIdxToBookstore < ActiveRecord::Migration[8.1]
  def change
    add_column :bookstores, :idx, :integer
  end
end
