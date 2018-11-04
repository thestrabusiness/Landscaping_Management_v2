class InvoiceItemsController < AuthenticatedController
  def new
    @invoice_item = InvoiceItem.new
    @invoice = Invoice.find(params[:invoice_id])

    collect_invoice_client_prices
  end

  def create
    @invoice_item = InvoiceItem.new(invoice_item_params)
    @invoice = Invoice.find(params[:invoice_id])
    @invoice_item.invoice = @invoice

    if params[:other_service_name].present? && params[:new_price].present?
      @invoice_item.name = params[:other_service_name].titleize
      @invoice_item.price = params[:new_price]
    else
      @invoice_item.price = ServicePrice.find_by(name: @invoice_item.name, client: @invoice.client).price
    end

    if @invoice_item.save && add_total_to_client_and_invoice
      redirect_to invoice_path(@invoice), notice: 'The item was successfully added to the invoice!'
    else
      collect_invoice_client_prices
      flash.now[:notice] = 'The invoice item could not be saved!'
      render :new
    end
  end

  def destroy
    set_invoice_item
    @invoice = @invoice_item.invoice

    if @invoice_item.destroy && subtract_total_from_client_and_invoice
      notice = 'Item was successfully removed from the invoice!'
    else
      notice = 'There was a problem removing the item from the invoice!'
    end

    redirect_to invoice_path(@invoice), notice: notice
  end

  private

  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end

  def add_total_to_client_and_invoice
    ActiveRecord::Base.transaction do
      @invoice.total += @invoice_item.total
      @invoice.client.balance += @invoice_item.total
      @invoice.save && @invoice.client.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def subtract_total_from_client_and_invoice
    ActiveRecord::Base.transaction do
      @invoice.total -= @invoice_item.total
      @invoice.client.balance -= @invoice_item.total
      @invoice.save && @invoice.client.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def collect_invoice_client_prices
    client_prices = @invoice.client.service_prices

    @options = client_prices.collect {|p| p.name } + ['Other']
  end

  def invoice_item_params
    params.require(:invoice_item).permit(:id,
                                         :invoice_id,
                                         :name,
                                         :price,
                                         :quantity)
  end

end
