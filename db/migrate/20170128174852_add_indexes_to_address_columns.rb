class AddIndexesToAddressColumns < ActiveRecord::Migration[5.0]
  def change
    add_index :clients, :billing_address_id
    add_index :invoices, :billing_address_id
    add_index :invoices, :job_address_id
  end
end
