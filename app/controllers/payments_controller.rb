class PaymentsController < AuthenticatedController
  def index
    @payments = Payment
                    .includes(:client, :invoice)
                    .order(date_received: :desc)
                    .distinct
                    .page(params[:page])
  end

  def show
    @originating_page = OriginatingPage.new(session[:originating_path] || payments_path)
    set_payment
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save && credit_payment_to_client_balance
      add_another_or_show_index
    else
      flash.now[:notice] = 'There was an error saving the payment.'
      render :new
    end
  end

  def edit
    set_payment
  end

  def update
    set_payment

    if  @payment.save && @payment.saved_change_to_amount? && update_client_balance_with_payment_amount_difference
      redirect_to payment_path(@payment), notice: 'Payment and client balance updated.'
    elsif @payment.save
      redirect_to payment_path(@payment), notice: 'Payment updated.'
    else
      flash.now[:notice] = 'There was an error saving the payment.'
      render :edit
    end
  end

  def destroy
    set_payment

    if @payment.update(deleted: true) && add_payment_amount_to_client_balance
      redirect_to payments_path, notice: 'Payment destroyed and client balance updated.'
    else
      redirect_to payments_path, notice: 'There was an error saving the payment.'
    end
  end

  private

  def add_another_or_show_index
    if params[:add_another]
      redirect_to new_payment_path(add_another: true), notice: 'Payment added'
    else
      redirect_to payments_path, notice: 'Payment added'
    end
  end

  def credit_payment_to_client_balance
    ActiveRecord::Base.transaction do
      @payment.client.balance -= @payment.amount
      @payment.client.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def add_payment_amount_to_client_balance
    ActiveRecord::Base.transaction do
      @payment.client.balance += @payment.amount
      @payment.client.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def update_client_balance_with_payment_amount_difference
    ActiveRecord::Base.transaction do
      @payment.client.balance -= @payment.amount_difference
      @payment.client.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:id,
                                    :invoice_id,
                                    :client_id,
                                    :payment_type,
                                    :amount,
                                    :date_received)
  end
end
