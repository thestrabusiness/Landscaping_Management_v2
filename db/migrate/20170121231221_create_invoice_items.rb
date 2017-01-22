class CreateInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :invoice_items do |t|
      t.references :invoice
      t.string :name
      t.money :price
      t.integer :quantity

      t.timestamps
    end
  end
end
