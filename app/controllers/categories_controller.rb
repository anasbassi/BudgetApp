class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, except: :splash

  def index
    @categories = Category.where(author_id: current_user.id)
    @totals = {}
    @categories.map do |category|
      category.deals.each do |deal|
        if @totals[category.id.to_s].nil?
          @totals[category.id.to_s] = deal.amount
        else
          @totals[category.id.to_s] += deal.amount
        end
      end
    end
  end

  def new
    @category = Category.new
  end

  def create
    category = Category.new(category_params)

    if category.save
      redirect_to categories_path
    else
      flash[:alert] = 'Category not created'
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    if @category.author != current_user
      flash[:alert] = 'You can only see what you created'
      redirect_to categories_path
    end
    @deals = @category.deals.order(created_at: :desc)
    @total = @deals.sum(:amount)
  end

  private

  def category_params
    params.require(:category).permit(:name, :icon).merge(author_id: current_user.id)
  end
end
