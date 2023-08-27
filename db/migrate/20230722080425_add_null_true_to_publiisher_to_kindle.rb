class AddNullTrueToPubliisherToKindle < ActiveRecord::Migration[7.0]
  def change
    change_column :kindlelists, :publisher, :string, null: true
  end
end
