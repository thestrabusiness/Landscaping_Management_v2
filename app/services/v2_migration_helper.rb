class V2MigrationHelper
  require 'csv'
  attr_accessor :client_csv, :invoice_csv, :invoice_item_csv, :service_csv, :service_price_csv, :payment_csv,
                :payments_not_imported

  def initialize(client_csv:, invoice_csv:, invoice_item_csv:, service_csv:, service_price_csv:, payment_csv:)
    @client_csv = client_csv
    @invoice_csv = invoice_csv
    @invoice_item_csv = invoice_item_csv
    @service_csv = service_csv
    @service_price_csv = service_price_csv
    @payment_csv = payment_csv

    @payments_not_imported = []
  end

  def self.perform(client_csv:, invoice_csv:, invoice_item_csv:, service_csv:, service_price_csv:, payment_csv:)
    new(client_csv: client_csv,
        invoice_csv: invoice_csv,
        invoice_item_csv: invoice_item_csv,
        service_csv: service_csv,
        service_price_csv: service_price_csv,
        payment_csv: payment_csv)
        .perform
  end

  def perform
    ActiveRecord::Base.transaction do
      migrate_services
      migrate_clients
    end

    puts "#{payments_not_imported.size} payment(s) not imported"
    payments_not_imported.each do |payment_hash|
      payment_hash.each { |k, v| puts "#{k}: #{v}".titleize }
      puts "*"*10
    end
  end

  private

  def migrate_clients
    CSV.foreach(client_csv, headers: true, header_converters: :symbol) do |row|
      existing_billing_address = find_existing_address row

      if existing_billing_address.present?
        client = existing_billing_address.client

        job_address = Address.create!(
            street: row[:job_address],
            city: row[:job_city],
            state: row[:job_state],
            zip: row[:job_zip],
            is_job_address?: true,
            position: row[:id],
            client: client
        )
      else
        client = Client.new(
            first_name: row[:first_name]&.strip&.titleize,
            last_name: row[:last_name]&.strip&.titleize,
            balance: row[:balance],
            phone_number: row[:phone_number],
            old_id: row[:id]
        )

        billing_address = client.addresses.build(
            street: row[:billing_address],
            city: row[:billing_city],
            state: row[:billing_state],
            zip: row[:billing_zip],
            is_job_address?: billing_and_job_address_match?(row),
            position: assign_position(row),
            client: client
        )

        client.billing_address = billing_address
        if client.save(validate: false)
          puts "Saved client: (#{client.old_id}) #{client.first_name} #{client.last_name}"
        else
          puts client.errors.full_messages
        end

        if billing_and_job_address_match? row
          job_address = billing_address
        else
          job_address = Address.create!(
              street: row[:job_address],
              city: row[:job_city],
              state: row[:job_state],
              zip: row[:job_zip],
              is_job_address?: true,
              position: row[:id],
              client: client
          )
        end
      end

      migrate_invoices(client.id, row[:id], job_address.id, client.billing_address_id)
      migrate_payments(client.id, row[:id])
      migrate_service_prices(client.id, row[:id], job_address.id)
    end
  end

  def migrate_invoices(client_id, old_client_id, job_address_id, billing_address_id)
    CSV.foreach(invoice_csv, headers: true, header_converters: :symbol) do |row|
      next unless row[:client_id] == old_client_id

      invoice = Invoice.new(client_id: client_id,
                            job_address_id: job_address_id,
                            billing_address_id: billing_address_id,
                            total: row[:total],
                            job_date: row[:date],
                            status: row[:status],
                            notes: row[:note],
                            old_id: row[:id],
                            performed_by: row[:performed_by],
                            created_at: row[:created_at])
      if invoice.save
        puts "     Saved invoice, old_id: #{invoice.old_id}"
      else
        puts "FAILED: #{invoice.errors.full_messages}"
      end
    end

    client_invoice_ids = Invoice.where(client_id: client_id).pluck(:old_id)

    CSV.foreach(invoice_item_csv, headers: true, header_converters: :symbol) do |row|
      next unless client_invoice_ids.include?(row[:invoice_id].to_i)
      invoice = Invoice.find_by(old_id: row[:invoice_id])
      InvoiceItem.create(invoice: invoice,
                         name: row[:name],
                         price: row[:price],
                         quantity: row[:quantity])
    end
  end

  def migrate_services
    CSV.foreach(service_csv, headers: true, header_converters: :symbol) do |row|
      Service.create(name: row[:name])
    end
  end

  def migrate_service_prices(client_id, old_client_id, address_id)
    CSV.foreach(service_price_csv, headers: true, header_converters: :symbol) do |row|
      next unless row[:client_id] == old_client_id
      ServicePrice.create(name: row[:name],
                          price: row[:price],
                          client_id: client_id,
                          address_id: address_id)
    end
  end

  def migrate_payments(client_id, old_client_id)
    CSV.foreach(payment_csv, headers: true, header_converters: :symbol) do |row|
      next unless row[:client_id] == old_client_id
      invoice = Invoice.find_by(old_id: row[:invoice_id])
      if invoice.nil?
        puts "Matching invoice not found for payment: Invoice ID ##{row[:invoice_id]}"
        payments_not_imported << {payment_id: row[:id], client_id: row[:client_id], invoice_id: row[:invoice_id] }
        next
      else
        Payment.create(amount: row[:amount],
                       client_id: client_id,
                       invoice_id: invoice.id,
                       payment_type: row[:payment_type],
                       date_received: row[:date],
                       created_at: row[:created_at])
      end
    end
  end

  def assign_position(row)
    row[:id] if billing_and_job_address_match?(row)
  end

  def billing_and_job_address_match?(row)
    row[:billing_address] == row[:job_address] && row[:billing_zip] == row[:job_zip]
  end

  def find_existing_address(row)
    Address.find_by(street: row[:billing_address],
                    city: row[:billing_city],
                    state: row[:billing_state],
                    zip: row[:billing_zip])
  end
end 
