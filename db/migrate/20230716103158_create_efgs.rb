class CreateEfgs < ActiveRecord::Migration[7.0]
  def change
    create_table :efgs do |t|
      t.integer :zid
      t.string :s

      t.timestamps
    end
  end
end
