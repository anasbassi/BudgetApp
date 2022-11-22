class DealsController < ApplicationController
  def index
    @category_id = params[:category_id]
    join = CategoryDeal.where(category_id: @category_id)
    deal_ids = join.pluck(:deal_id)
    @deals = []
    deal_ids.map do |id|
      @deals << Deal.find(id)
    end
    @deals = @deals.sort_by(&:created_at).reverse
    # @deals = join.where()where(author_id: current_user.id).order(created_at: :desc)
    @total = @deals.map(&:amount).inject(0, &:+)
  end

  def new
    @deal = Deal.new
  end

  def create
    category = Category.find_by_id(params[:category_id])
    @deal = category.deals.new(deal_params)

    if @deal.save
      join = CategoryDeal.create(category_id: category.id, deal_id: @deal.id)
      if join.nil?
        flash[:alert] = @deal.errors.messages
        render :new
      else
        redirect_to category_deals_path(category.id)
      end
    else
      flash[:alert] = @deal.errors.messages
      render :new
    end
  end

  def deal_params
    params.require(:deal).permit(:name, :amount).merge(author_id: current_user.id)
  end
end
