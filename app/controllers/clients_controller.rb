class ClientsController < AuthenticatedController
  def index
    @query = params[:query]
    @clients = Client.preload(:addresses).search(@query).uniq
  end

  def show
    set_client

    @originating_page = OriginatingPage.new(session[:originating_path] || clients_path)
    @active_section = params[:active_section] || 'overview'

    @invoices = @client.invoices.order(created_at: :desc).preload(:job_address)
    @payments = @client.payments.order(created_at: :desc)
    @estimates = @client.estimates.order(created_at: :desc)

    @recent_invoices = @invoices.take(5)
    @recent_payments = @payments.take(5)
    @recent_estimates = @estimates.take(5)
  end

  def new
    @client = Client.new
    @billing_address = Address.new
  end

  def create
    @client = Client.new(client_params)
    @billing_address = Address.new(address_params)
    @billing_address.client = @client
    @client.billing_address = @billing_address

    if @client.save
      redirect_to client_path(@client), notice: 'The client was successfully saved!'
    else
      flash.now[:notice] = 'The client could not be saved!'
      render :new
    end
  end

  def edit
    set_client
    @billing_address = @client.billing_address
  end

  def update
    set_client
    if @client.update(client_params)
      redirect_to client_path(@client), notice: 'The client was successfully updated!'
    else
      flash.now[:notice] = 'The client could not be updated!'
      render :edit
    end
  end

  def destroy
    set_client
    @client.deleted = true
    @client.save
  end

  def reminders
    client_ids = Client.where('CAST(balance AS numeric) > ?', 0.0).pluck(:id)
    pdf = ReminderPDFGenerator.generate(client_ids)
    send_data(pdf, filename: "reminders_#{Date.current.strftime('%m_%d_%Y')}.pdf")
  end

  def summary
    address_ids = Address.pluck(:id)
    pdf = ClientListPDFGenerator.generate(address_ids)
    send_data(pdf, filename: "client_list_#{Date.current.strftime('%m_%d_%Y')}.pdf")
  end

  private

  def set_client
    @client = Client.find(params[:id])
    if @client.deleted?
      raise ActiveRecord::NotFound
    end
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :phone_number, :email, :billing_address_id, :search)
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip, :client_id)
  end
end
