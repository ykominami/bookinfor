class CreateReadstatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :readstatuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
