class AddJobAndBillingAddressToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :billing_address, type: :uuid, references: :invoices
    add_reference :invoices, :job_address, type: :uuid, references: :invoices
  end
end

