class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :show, :edit, :update]

  def index
  	@users = User.all
  end

  def show
  	@user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params_user)
      redirect_to admin_user_path(@user.id)
    else
      render :edit
    end
  end

  private
  def params_user
    params.require(:user).permit(:email, :lastname, :lastname_kana, :firstname, :firstname_kana, :nickname, :status)
  end

end
