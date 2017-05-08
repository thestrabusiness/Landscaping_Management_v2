class CreateEstimates < ActiveRecord::Migration[5.0]
  def change
    create_table :estimates do |t|
      t.datetime :date
      t.money :total
      t.string :notes

      t.references :address, index: true

      t.timestamps
    end

    create_table :estimates_items do |t|
      t.string :description
      t.money :price
      t.integer :quantity

      t.references :estimate, index: true

      t.timestamps
    end
  end
end
