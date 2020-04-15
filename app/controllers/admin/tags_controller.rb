class Admin::TagsController < ApplicationController
  def index
  	@tag = Tag.new
  	@tags = Tag.all
  end

  def create
	@tag = Tag.new(params_tag)
	if @tag.save
		redirect_to admin_tags_path
	else
		@tags = Tag.all
		render :index
	end
  end

  def edit
  	@tag = Tag.find(params[:id])
  end

  def update
  	@tag = Tag.find(params[:id])
  	if @tag.update(params_tag)
  		redirect_to admin_tags_path
  	else
  		render :edit
  	end
  end

  def destroy
  	Tag.destroy(params[:id])
  	flash[:success] = "タグを削除しました。"
  	redirect_to admin_tags_path
  end

  private
  def params_tag
  	params.require(:tag).permit(:name)
  end

end
