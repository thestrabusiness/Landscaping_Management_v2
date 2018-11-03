class V2MigrationHelper
  attr_accessor :client_hash, :invoice_hash, :invoice_item_hash, :service_hash, :service_price_hash

  def initialize(client_yml:, invoice_yml:, invoice_item_yml:, service_yml:, service_price_yml:)
    @client_hash = Psych.parse(client_yml).to_ruby.with_indifferent_access
    @invoice_hash = Psych.parse(invoice_yml).to_ruby.with_indifferent_access
    @service_hash = Psych.parse(service_yml).to_ruby.with_indifferent_access
    @service_price_hash = Psych.parse(service_price_yml).to_ruby.with_indifferent_access
  end

  def self.perform(client_yml:, invoice_yml:, invoice_item_yml:, service_yml:, service_price_yml:)
    new(client_yml: client_yml,
        invoice_yml: invoice_yml,
        invoice_item_yml: invoice_item_yml,
        service_yml: service_yml,
        service_price_yml: service_price_yml)
        .perform
  end

  def perform
    migrate_clients
    migrate_services
    migrate_service_prices
    migrate_invoices
  end

  private

  def migrate_clients
    client_hash.each do |object|
      @yml_client_attributes = object[1]

      @client = Client.new(client_attributes)
      @address = Address.new(billing_address_attributes)

      @address.client = @client
      @client.billing_address = @address
      @client.save(validate: false)

      @client.billing_address.client = @client
      @client.billing_address.save(validate: false)
    end
  end

  def migrate_service_prices
    service_price_hash.each do |object|
      params = object[1]
      client = Client.find_by(old_id: params[:client_id])
      ServicePrice.create(
          name: params[:name],
          price: params[:price],
          client: client,
          address: client.billing_address
      )
    end
  end

  def migrate_invoices
    invoice_hash.each do |object|
      params = object[1]
      client = Client.find_by(old_id: params[:client_id])
      Invoice.create(
          client: client,
          job_address: client.billing_address,
          billing_address: client.billing_address,
          total: params[:total],
          job_date: params[:date],
          status: params[:status],
          notes: params[:note],
          old_id: params[:id]
      )
    end

    invoice_item_hash.each do |object|
      params = object[1]
      invoice = Invoice.find_by(old_id: params[:invoice_id])
      InvoiceItem.create(
          invoice: invoice,
          name: params[:name],
          price: params[:price],
          quantity: params[:quantity]
      )
    end
  end

  def migrate_services
    service_hash.each do |object|
      Service.create(name: object[1][:name])
    end
  end

  def corrected_zip
    zip = @yml_client_attributes[:zip]
    zip.length == 4 ? zip.prepend('0') : zip
  end

  def billing_and_job_addresses_match?
    @yml_client_attributes[:billing_address].to_s.downcase.strip == @yml_client_attributes[:job_address].to_s.downcase.strip
  end

  def assign_position
    billing_and_job_addresses_match? ? @yml_client_attributes[:id] : nil
  end

  def client_attributes
    {
        first_name: @yml_client_attributes[:first_name].try(:strip),
        last_name: @yml_client_attributes[:last_name].try(:strip),
        balance: @yml_client_attributes[:balance],
        phone_number: @yml_client_attributes[:phone_number],
        old_id: @yml_client_attributes[:id]
    }
  end

  def billing_address_attributes
    {
        street: @yml_client_attributes[:billing_address].to_s.strip,
        city: @yml_client_attributes[:city].to_s.strip.titleize,
        state: @yml_client_attributes[:state].to_s.strip,
        zip: corrected_zip,
        is_job_address?: billing_and_job_addresses_match?,
        position: assign_position

    }
  end
end
