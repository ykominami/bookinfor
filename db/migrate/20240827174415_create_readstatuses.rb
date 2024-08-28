class CreateReadstatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :readstatuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
