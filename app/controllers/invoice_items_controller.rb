class InvoiceItemsController < ApplicationController
  def new
    @invoice_item = InvoiceItem.new
    @invoice = Invoice.find(params[:invoice_id])
  end

  def create
    @invoice_item = InvoiceItem.new(invoice_item_params)
    @invoice = Invoice.find(params[:invoice_id])
    @invoice_item.invoice = @invoice


    if @invoice_item.save!
      redirect_to invoice_path(@invoice), notice: 'The item was successfully added to the invoice!'
    else
      flash.now[:notice] = 'The invoice item could not be saved!'
      render :new
    end
  end

  def destroy
    set_invoice_item
    @invoice = @invoice_item.invoice

    if @invoice_item.destroy
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

  def invoice_item_params
    params.require(:invoice_item).permit(:id,
                                         :name,
                                         :price,
                                         :quantity)
  end

end