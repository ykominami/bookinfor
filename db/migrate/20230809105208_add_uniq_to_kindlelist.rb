class AddUniqToKindlelist < ActiveRecord::Migration[7.0]
  def change
    add_index :kindlelists, [:asin], unique: true
  end
end
