class EstimateItemsController < AuthenticatedController
  def new
    @estimate_item = EstimateItem.new
    @estimate = Estimate.find(params[:estimate_id])
  end

  def create
    @estimate_item = EstimateItem.new(estimate_item_params)
    @estimate = Estimate.find(params[:estimate_id])
    @estimate_item.estimate = @estimate

    if @estimate_item.save && add_total_estimate
      redirect_to estimate_path(@estimate), notice: 'The item was successfully added to the estimate!'
    else
      flash.now[:notice] = 'The estimate item could not be saved!'
      render :new
    end
  end

  def destroy
    set_estimate_item
    @estimate = @estimate_item.estimate

    if @estimate_item.destroy && subtract_total_estimate
      notice = 'Item was successfully removed from the estimate!'
    else
      notice = 'There was a problem removing the item from the estimate!'
    end

    redirect_to estimate_path(@estimate), notice: notice
  end

  private

  def set_estimate_item
    @estimate_item = EstimateItem.find(params[:id])
  end

  def add_total_estimate
    ActiveRecord::Base.transaction do
      @estimate.total += @estimate_item.total
      @estimate.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def subtract_total_estimate
    ActiveRecord::Base.transaction do
      @estimate.total -= @estimate_item.total
      @estimate.save
    end

    return true

  rescue ActiveRecord::Rollback
    return false
  end

  def estimate_item_params
    params.require(:estimate_item).permit(:id,
                                         :estimate_id,
                                         :description,
                                         :price,
                                         :quantity)
  end

end
