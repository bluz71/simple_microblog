class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # redirect_to will result in a new HTTP request. In this case a 
      # 'user with-ID GET' to users#show (aka the show method above).
      redirect_to @user
    else
      # render the 'new' view, unlike redirect_to, will be handled in this same
      # request.
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
