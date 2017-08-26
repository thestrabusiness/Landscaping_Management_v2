class EstimatePDFGenerator
  include Prawn::View
  attr_accessor :estimates

  def initialize(estimate_ids)
    @estimates = Estimate.where(id: estimate_ids)
  end

  def self.generate(estimate_ids)
    new(estimate_ids).generate
  end

  def generate
    @estimates.each do |estimate|

      move_down 30
      text 'Moffa Landscaping', style: :bold, size: 36
      text '27 Bryant Street', size: 18
      text 'Revere, MA 02151', size: 18

      move_down 30
      text 'Estimate', style: :bold, size: 24

      move_down 25
      text estimate.client.full_name
      draw_text "Estimate number: #{estimate.id}", at: [375, cursor+5]
      text estimate.address.street
      draw_text "Estimate date: #{estimate.date.strftime('%m/%d/%Y')}", at: [375, cursor+5]
      text "#{estimate.address.city}, #{estimate.address.state} #{estimate.address.zip}"

      if estimate.notes.present?
        move_down 25
        text "<b>Notes:</b> #{estimate.notes}", inline_format: true
      end

      move_down 20
      table estimate_details(estimate, estimate.estimate_items) do
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
      text 'If you have any questions, please call 781-526-2967.'

      start_new_page if @estimates.count > 1 && !(estimate == @estimates.last)
    end

    self.render
  end

  def estimate_details(estimate, estimate_items)
    details_table = [['No.', 'Service', 'Qt.', 'Cost', 'Total']]
    item_rows = estimate_items.each_with_index.map do |item, i|
      [
          i+1,
          item.description,
          item.quantity,
          item.price,
          item.quantity * item.price
      ]
    end

    item_rows.each { |row| details_table << row}
    details_table << ['','', '', 'Estimate Total', estimate.total]
    details_table
  end
end
