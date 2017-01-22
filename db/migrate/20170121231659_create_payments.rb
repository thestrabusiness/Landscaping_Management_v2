class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.references :client
      t.references :invoice

      t.money :amount
      t.string :payment_type

      t.timestamps
    end
  end
end
