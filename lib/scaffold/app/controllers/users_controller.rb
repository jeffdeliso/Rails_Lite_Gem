class UsersController < ApplicationController
  protect_from_forgery

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to  users_url
    else
      flash.now[:errors] = @user.errors
      render :new
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  before_action :ensure_logout, only: [:new, :create]
  before_action :ensure_login, only: [:index, :show, :destroy]
end
