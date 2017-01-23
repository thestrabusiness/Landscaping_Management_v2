class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def show
    set_client
    @billing_address = @client.billing_address
    @addresses = @client.addresses
    @invoices = @client.invoices
    @payments = @client.payments
  end

  def new
    @client = Client.new
    @billing_address = Address.new
  end

  def create
    binding.pry
    @client = Client.new(client_params)
    @billing_address = Address.new(address_params)
    @client.billing_address = @billing_address.create(params[address_params])

    if @client.save! && @billing_address.save!
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
    if client.save!
      redirect_to client_path(@client), notice: 'The client was successfully saved!'
    else
      @address = @client.billing_address
      flash.now[:notice] = 'The client could not be updated!'
      render :edit
    end
  end

  def destroy

  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :phone_number, :email)
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip)
  end
end