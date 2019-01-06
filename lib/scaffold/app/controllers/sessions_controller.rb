class SessionsController < ApplicationController
  protect_from_forgery

  def new
    @user = User.new
  end

  def create
    username = session_params[:username]
    password = session_params[:password]

    @user = User.find_by_credentials(username, password)
    if @user
      login(@user)
      redirect_to users_url
    else
      flash.now[:errors] = ['invalid username/password']
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_sessions_url
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end

  before_action :ensure_logout, only: [:new, :create]
end
