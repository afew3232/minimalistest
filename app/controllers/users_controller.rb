class UsersController < ApplicationController
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
  		redirect_to user_path(@user.id)
  	else
  		render :edit
  	end
  end

  private
  def params_user
  	params.require(:user).permit(:email, :password, :nickname, :lastname, :lastname_kana, :firstname, :firstname_kana)
  end

end
