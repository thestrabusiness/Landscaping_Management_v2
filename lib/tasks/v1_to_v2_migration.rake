namespace :v1_to_v2_migration do
  desc 'Migrate data to new db structure'
  task migrate: :environment do

    def migrate_clients
      clients_psych_object.each do |object|
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

    def migrate_client_prices
      client_price_psych_object.each do |object|
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
      invoices_psych_object.each do |object|
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

      invoice_items_psych_object.each do |object|
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
      service_psych_object.each do |object|
        Service.create(name: object[1][:name])
      end
    end

    def client_price_psych_object
      Psych.load_file(Rails.root.join('ClientPrice.yml').to_s).with_indifferent_access
    end

    def service_psych_object
      Psych.load_file(Rails.root.join('Service.yml').to_s).with_indifferent_access
    end

    def clients_psych_object
      Psych.load_file(Rails.root.join('Client.yml').to_s).with_indifferent_access
    end

    def invoices_psych_object
      Psych.load_file(Rails.root.join('Invoice.yml').to_s).with_indifferent_access
    end

    def invoice_items_psych_object
      Psych.load_file(Rails.root.join('InvoiceItem.yml').to_s).with_indifferent_access
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

    migrate_clients
    migrate_services
    migrate_client_prices
    migrate_invoices
  end
end

# ActiveRecord::Base.connection.execute("select * from clients where not(job_address like format('%%%s%%', billing_address))")
