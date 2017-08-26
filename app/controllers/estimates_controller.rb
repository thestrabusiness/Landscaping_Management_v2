class EstimatesController < ApplicationController
  def index
    @estimates = Estimate.all
  end

  def show
    @originating_page = OriginatingPage.new(session[:originating_path] || estimates_path)

    set_estimate

    @client = @estimate.client
    @address = @estimate.address
    @estimate_items = EstimateItem.where(estimate: @estimate)
  end

  def new
    @estimate = Estimate.new
  end

  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.address = Address.find(estimate_params[:address_id])

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
    set_estimate

    if @estimate.update(estimate_params)
      redirect_to estimate_path(@estimate), notice: 'The estimate was successfully updated!'
    else
      flash.now[:notice] = 'The estimate could not be updated!'
      render :edit
    end
  end

  def destroy
    set_estimate
    @estimate.update(deleted:  true)
  end

  def download_pdf
    set_estimate
    pdf = EstimatePDFGenerator.generate(@estimate.id)
    send_data(pdf, filename: "#{@estimate.client.underscore_name}_estimate#{@estimate.id}.pdf")
  end

  def download_pdf_collection
    estimate_ids = params[:selected_estimates]
    pdf = EstimatePDFGenerator.generate(estimate_ids)
    send_data(pdf, filename: "estimates_#{Date.today.strftime('%m_%d_%Y')}.pdf")
  end

  private

  def set_estimate
    @estimate = Estimate.find(params[:id])
    if @estimate.deleted?
      raise ActiveRecord::NotFound
    end
  end

  def estimate_params
    params.require(:estimate).permit(:id, :address_id, :notes, :date)
  end

end
