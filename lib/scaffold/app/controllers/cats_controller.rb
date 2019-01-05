class CatsController < ApplicationController
  protect_from_forgery

  def index
    @cats = Cat.all
  end
  
  def new
    @cat = Cat.new
  end
  
  def show
    current_cat
  end
  
  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors
      render :new
    end
  end
  
  def edit
    current_cat
  end
  
  def update
    if current_cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors
      render :edit
    end
  end
  
  def destroy
    current_cat.destroy
    redirect_to cats_url
  end
  
  private

  def current_cat
    @cat ||= Cat.find(params[:id])
  end
  
  def cat_params
    params.require(:cat).permit(:name, :owner_id)
  end

  before_action :ensure_login, only: [:new, :create, :edit, :update, :destroy]
end