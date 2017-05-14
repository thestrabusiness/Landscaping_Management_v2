class EstimatesController < ApplicationController
  def index
    @estimates = Estimate.all
  end

  def show
    @originating_page = OriginatingPage.new(session[:originating_path] || estimates_path)

    set_estimate

    @client = @estimate.client
    @job_address = @estimate.job_address
    @estimate_items = EstimateItem.where(estimate: @estimate)
  end

  def new
    @estimate = Estimate.new
  end

  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.job_address = Address.find(estimate_params[:job_address_id])
    @estimate.client = @estimate.job_address.client

    if @estimate.save
      redirect_to estimate_path(@estimate), notice: 'The estimate was successfully saved!'
    else
      flash.now[:notice] = 'The estimate could not be saved!'
      render :new
    end
  end

  def edit
    set_estimate
  end

  def update
    if @estimate.update(estimate_params)
      redirect_to client_path(@client), notice: 'The estimate was successfully updated!'
    else
      flash.now[:notice] = 'The estimate could not be updated!'
      render :edit
    end
  end

  def destroy
    set_estimate
    @estimate.update(deleted:  true)
  end

  private

  def set_estimate
    @estimate = Estimate.find(params[:id])
    if @estimate.deleted?
      raise ActiveRecord::NotFound
    end
  end

  def estimate_params
    params.require(:estimate).permit(:id,
                                     :total,
                                     :performed_by,
                                     :job_date,
                                     :status,
                                     :job_address_id,
                                     :notes)
  end

end
