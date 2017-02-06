class AddressesController < ApplicationController
  def new
    @address = Address.new
    @client = Client.find(params[:client_id])
  end

  def create
    @address = Address.new(address_params)
    @client = Client.find(params[:client_id])

    @address.client = @client

    if @address.save
      redirect_to @client, notice: 'Address was successfully added!'
    else
      flash.now[:notice] = 'There was a problem saving the address!'
      render :new
    end
  end

  def edit
    set_address
    @client = Client.find(params[:client_id])
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip, :client_id)
  end
end