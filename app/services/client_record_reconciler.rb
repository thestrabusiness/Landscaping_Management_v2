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
    reconciled_addresses = duplicate_client.addresses

    relationships_to_update.each do |relationship|
      duplicate_client.send(relationship).update_all(client_id: master_client.id)
    end

    reconciled_addresses.update_all(billing_address: false)
  end

  def relationships_to_update
    [:invoices, :payments, :estimates, :addresses]
  end
end
