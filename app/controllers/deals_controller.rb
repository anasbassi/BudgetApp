class DealsController < ApplicationController
  def new
    @category = Category.find(params[:category_id])

    if @category.author == current_user
      @deal = Deal.new
    else
      flash[:alert] = 'You can only create deals from your categories'
      redirect_to categories_path
    end
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
        redirect_to category_path(category.id)
      end
    else
      flash[:alert] = @deal.errors.messages
      render :new
    end
  end

  private

  def deal_params
    params.require(:deal).permit(:name, :amount).merge(author_id: current_user.id)
  end
end
