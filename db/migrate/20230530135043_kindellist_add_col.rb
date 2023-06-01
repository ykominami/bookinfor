class KindellistAddCol < ActiveRecord::Migration[7.0]
  def change
      add_column :kindlelists, :read_status, :integer
      add_column :kindlelists, :category, :string
  end
end
