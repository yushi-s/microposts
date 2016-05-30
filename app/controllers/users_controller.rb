class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :following, :followers, :like]
  before_action :correct_user, only:[:edit, :update]

  def show
    @microposts = @user.microposts.order(created_at: :desc)
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
    if @user.update(user_params)
      flash[:success] = t("all_changes_saved")
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def following
    @title = t("following")
    @users = @user.following_users
    render 'show_follow'
  end

  def followers
    @title = t("followers")
    @users = @user.follower_users
    render 'show_follow'
  end

  def like
    @title = t("likes")
    @microposts = current_user.like_microposts.order(created_at: :desc)
    render 'show_like'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :prefecture, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to root_url unless @user == current_user
  end
end
