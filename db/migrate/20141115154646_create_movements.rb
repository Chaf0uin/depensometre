class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :name
      t.string :category
      t.decimal :amount
      t.boolean :movementType
      t.datetime :date

      t.timestamps
    end
  end
end
