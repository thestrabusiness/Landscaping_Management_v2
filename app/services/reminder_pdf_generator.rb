class ReminderPDFGenerator
  include Prawn::View
  attr_accessor :clients

  def initialize(client_ids)
    @clients = Client.where(id: client_ids).preload(:billing_address)
  end

  def self.generate(client_ids)
    new(client_ids).generate
  end

  def generate
    @clients.each do |client|

      move_down 30
      text 'Moffa Landscaping', style: :bold, size: 24
      text '27 Bryant Street', size: 18
      text 'Revere, MA 02151', size: 18

      move_down 30
      text client.full_name, style: :bold, size: 16
      text client.billing_address.street, size: 14
      text "#{client.billing_address.city}, #{client.billing_address.state} #{client.billing_address.zip}", size: 14

      move_down 30
      text 'Valued client,'

      move_down 30
      text 'You are receiving this letter because you have an outstanding balance according' +
           'to our records. We would greatly appreciate it if you could pay your balance before' +
           ' the beginning of the next season.'

      move_down 12
      text "Your outstanding balance as of #{Date.current} is:"

      move_down 35
      draw_text "$#{client.balance}", at: [50, cursor], style: :bold, size: 18
      move_down 30

      text 'If you believe you\'ve received this letter in error, or if you have any questions, ' +
           'please feel free to call us at (781) 289-1483 or (781) 526-2967.'

      move_down 90
      text 'Thank you,'
      move_down 12
      text 'Moffa Landscaping', style: :bold, size: 18

      start_new_page if @clients.size > 1 && client != clients.last
    end

    self.render
  end
end
