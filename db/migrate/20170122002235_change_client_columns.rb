class ChangeClientColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :clients, :phone_numbers, :phone_number
    change_column :clients, :balance, :money, default: 0
  end
end
