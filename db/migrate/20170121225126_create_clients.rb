class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.money :balance
      t.string :email
      t.string :phone_numbers

      t.timestamps
    end
  end
end
