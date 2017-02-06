class ServicePricesController < ApplicationController
  def new
    @service_price = ServicePrice.new
    @address = Address.find(params[:address_id])
  end

  def create
    @service_price = ServicePrice.new(service_price_params)
    @address = Address.find(params[:address_id])
    @service_price.address = @address
    @service_price.client = @address.client

    if @service_price.save
      redirect_to @service_price.client, notice: 'Successfully added new service!'
    else
      flash.now[:notice] = 'The service could not be saved!'
      render :new
    end
  end

  private

  def service_price_params
    params.require(:service_price).permit(:id, :name, :price, :client_id, :address_id)
  end
end