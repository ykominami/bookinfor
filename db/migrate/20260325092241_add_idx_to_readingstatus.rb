class AddIdxToReadingstatus < ActiveRecord::Migration[8.1]
  def change
    add_column :readingstatuses, :idx, :integer
  end
end
