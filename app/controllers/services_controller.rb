class ServicesController < ApplicationController
  def index
    @services = Service.all
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      render :index, notice: 'Service added!'
    else
      render :new, notice: "Service couldn't be added"
    end
  end

  def destroy
    @service = Service.find(params[:id])

    if @service.destroy
      render :index, notice: "#{@service.name} was removed!"
    else
      render :index, notice: "Service couldn't be removed!"
    end
  end

  private

  def service_params
    params.require(:service).permit(:id, :name)
  end
end