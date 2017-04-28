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
      redirect_to services_path, notice: 'Service added!'
    else
      render :new, notice: "Service couldn't be added"
    end
  end

  def destroy
    @service = Service.find(params[:id])

    if @service.destroy
      redirect_to services_path, notice: "#{@service.name} was removed!"
    else
      redirect_to services_path, notice: "Service couldn't be removed!"
    end
  end

  private

  def service_params
    params.require(:service).permit(:id, :name)
  end
end