class AddIdxToReadstatus < ActiveRecord::Migration[8.1]
  def change
    add_column :readstatuses, :idx, :integer
  end
end
