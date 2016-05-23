class UsersController < ApplicationController
  before_action :correct_user, only:[:edit, :update]

  def show
    @user = User.find(params[:id])
    # @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
    #   redirect_to current_user
    # else
    flash.now[:success] = "All Changes Saved"
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :prefecture, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless @user == current_user
  end
end
