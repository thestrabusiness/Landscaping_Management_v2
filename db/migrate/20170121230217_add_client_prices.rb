class AddClientPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :client_prices do |t|
      t.string :name
      t.money :price
      t.references :client
      t.timestamps
    end
  end
end
