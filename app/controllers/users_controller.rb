class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @posts = Post.where(user_id: @user.id)
  end

  def edit
  end

  def update
  	if @user.update(params_user)
  		redirect_to user_path(@user.id)
  	else
  		render :edit
  	end
  end

  private
  def params_user
  	params.require(:user).permit(:email, :password, :nickname, :lastname, :lastname_kana, :firstname, :firstname_kana)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
