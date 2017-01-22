class AddBillingAddress < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients, :billing_address, type: :uuid, references: :clients
  end
end
