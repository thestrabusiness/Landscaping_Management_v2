class ChangeUuidsToInt < ActiveRecord::Migration[5.0]
  def change
    remove_column :clients, :billing_address_id
    add_column :clients, :billing_address_id, :integer
    remove_column :invoices, :billing_address_id
    add_column :invoices, :billing_address_id, :integer
    remove_column :invoices, :job_address_id
    add_column :invoices, :job_address_id, :integer
  end
end
