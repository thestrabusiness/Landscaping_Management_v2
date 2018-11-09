class ClientRecordReconciler
  attr_accessor :duplicate_client, :master_client

  def initialize(master_client:, duplicate_client:)
    @master_client = master_client
    @duplicate_client = duplicate_client
  end

  def self.perform(master_client:, duplicate_client:)
    new(master_client: master_client, duplicate_client: duplicate_client).perform
  end

  def perform
    reconciled_addresses = billing_addresses_match? ? duplicate_client.job : duplicate_client.addresses

    relationships_to_update.each do |relationship|
      duplicate_client.send(relationship).update_all(client_id: master_client.id)
    end

    reconciled_addresses.update_all(billing_address: false)

    master_client.reload
    invoices_total = master_client.invoices.sum(:total)
    payments_total = master_client.payments.sum(:amount)
    master_client.update_column(:balance, (invoices_total + payments_total))
  end

  private

  def billing_addresses_match?
    @master_client.billing_address.street == @duplicate_client.billing_address.street
  end

  def relationships_to_update
    [:invoices, :payments, :estimates, addresses_to_update]
  end

  def addresses_to_update
    billing_addresses_match? ? :job : :addresses
  end
end
