class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!, only: [:show, :edit, :update]
  before_action :set_admin, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
  	if @admin.update(params_admin)
  		redirect_to admin_admin_path(@admin.id), flash: { success: "管理者情報を編集しました。" }
  	else
  		render :edit
  	end
  end

  private
  def params_admin
  	params.require(:admin).permit(:email)
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

end
