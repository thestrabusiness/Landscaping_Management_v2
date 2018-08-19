class ClientListPDFGenerator
  include Prawn::View
  attr_accessor :addresses

  def initialize(client_ids)
    @addresses = Address
                     .where(client_id: client_ids)
                     .includes(client: :payments)
                     .order(:position)
  end

  def self.generate(client_ids)
    new(client_ids).perform
  end

  def perform
    table client_summary_table do
      self.row_colors = ['FFFFFF', 'F0F0F0']
      self.width = 550
      cells.borders = [:bottom]
      row(0).font_style = :bold
    end

    self.render
  end

  def client_summary_table
    table_data = []
    headers = ['ID', 'Name', 'Job Address', 'Balance', 'Last Payment']
    table_data << headers

    addresses.each do |address|
      table_data << [
          address.client.id,
          address.client.full_name,
          address.full_address,
          address.client.balance,
          address.client.last_payment
      ]
    end

    table_data
  end
end
