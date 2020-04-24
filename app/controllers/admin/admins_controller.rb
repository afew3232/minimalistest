class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!, only: [:show, :edit, :update]
  def show
  	@admin = Admin.find(params[:id])
  end

  def edit
  	@admin = Admin.find(params[:id])
  end

  def update
  	@admin = Admin.find(params[:id])
  	if @admin.update(params_admin)
  		redirect_to admin_admin_path(@admin.id)
  	else
  		render :edit
  	end
  end

  private
  def params_admin
  	params.require(:admin).permit(:email)
  end

end
