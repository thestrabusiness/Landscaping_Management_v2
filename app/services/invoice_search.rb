class InvoiceSearch
  attr_reader :date_from, :date_to, :params

  def initialize(params)
    @params = params || {}
    @date_from = date_from_helper.parse(30.days.ago.to_date)
    @date_to = date_to_helper.parse(Date.today)
  end

  def self.perform(params)
    new(params).perform
  end

  def perform
    scope
        .includes(:job_address, :client)
        .order(job_date: :desc)
        .distinct
        .page(params[:page])
        .per(invoices_per_page)
  end

  private

  def scope
    if all_date_params_present?
      Invoice.where('job_date BETWEEN ? AND ?', date_from, date_to)
    else
      Invoice
    end
  end

  def all_date_params_present?
    date_to_helper.all_present? && date_from_helper.all_present?
  end

  def date_to_helper
    DateSelectHelper.new(params, :invoice, :date_to)
  end

  def date_from_helper
    DateSelectHelper.new(params, :invoice, :date_from)
  end

  def invoices_per_page
    all_date_params_present? ? Invoice.count : 30
  end
end
