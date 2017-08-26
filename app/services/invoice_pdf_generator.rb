class InvoicePDFGenerator
  include Prawn::View
  attr_accessor :invoices

  def initialize(invoice_ids)
    @invoices = Invoice.where(id: invoice_ids)
  end

  def self.generate(invoice_ids)
    new(invoice_ids).generate
  end

  def generate
    @invoices.each do |invoice|

      move_down 30
      text 'Moffa Landscaping', style: :bold, size: 36
      text '27 Bryant Street', size: 18
      text 'Revere, MA 02151', size: 18

      move_down 30
      text 'Invoice', style: :bold, size: 24

      move_down 25
      text invoice.client.full_name
      draw_text "Invoice number: #{invoice.id}", at: [375, cursor+5]
      text invoice.job_address.street
      draw_text "Invoice date: #{invoice.job_date.strftime('%m/%d/%Y')}", at: [375, cursor+5]
      text "#{invoice.job_address.city}, #{invoice.job_address.state} #{invoice.job_address.zip}"
      draw_text "Payment due by: #{30.days.from_now.strftime('%m/%d/%Y')}", at: [375, cursor+5]

      if invoice.notes.present?
        move_down 25
        text "<b>Notes:</b> #{invoice.notes}", inline_format: true
      end

      move_down 20
      table invoice_details(invoice, invoice.invoice_items) do
        self.row_colors = ['F0F0F0', 'FFFFFF']
        self.width = 550
        self.position = :center
        self.header = true

        cells.borders = []
        cells.padding = [12, 8, 8, 8]

        column(-1).align = :right
        column(-2).align = :right

        column(1).width = 250
        column(0).borders = [:left]
        column(-1).borders = [:right]
        row(0).borders = [:top, :bottom]
        row(0).column(0).borders = [:top, :bottom, :left]
        row(0).column(-1).borders = [:top, :bottom, :right]
        row(-1).borders = [:bottom]
        row(-1).column(0).borders = [:bottom, :left]
        row(-1).column(-1).borders = [:bottom, :right]
        row(0).font_style = :bold
      end

      move_down 20
      text 'Please make checks payable to: Aurelio Moffa, P.O. Box 555, Revere, MA' +
           '02151. If you have any questions please call 781-526-2967.'

      start_new_page if @invoices.count > 1 && !(invoice == @invoices.last)
    end

    self.render
  end

  def invoice_details(invoice, invoice_items)
    details_table = [['No.', 'Service', 'Qt.', 'Cost', 'Total']]
    item_rows = invoice_items.each_with_index.map do |item, i|
      [
          i+1,
          item.name,
          item.quantity,
          item.price,
          item.quantity * item.price
      ]
    end

    item_rows.each { |row| details_table << row}

    details_table << ['','', '', 'Subtotal:', invoice.total]

    case invoice.check_balance_forward
    when 'zero-balance', 'positive-balance'
      details_table << ['', '','', 'Past Due:', invoice.balance_forward]
      details_table << ['', '', '', 'Total Due:', invoice.amount_due]
    when 'payment-received'
      details_table << ['', '', '', 'Payment Received:', invoice.client.last_payment]
      details_table << ['', '', '', 'Total Due:', invoice.client.balance]
    end

    details_table
  end
end
