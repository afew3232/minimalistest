class Admin::PostsController < ApplicationController
  def index
  	@posts = Post.all.includes(:user)
  end

  def show
  	@post = Post.find(params[:id])
  end

  def edit
  	@post = Post.find(params[:id])
  end

  def confirm_edit
  	@post = Post.new(params_post)
    @post_image = @post.image
  	@post.id = params[:id]
  	unless @post.valid? #valid?(有効ですか?) == falseならrender :new
  		render :edit
  	end
  end

  def update
  	@post = Post.find(params[:id])
    @post.post_image.retrieve_from_cache! params[:cache][:post_image]
  	if @post.update(params_post)
  		redirect_to admin_post_path(@post.id)
  	else
  		flash[:notice] = "エラーが発生しました。failed to update."
  		render :confirm_edit
  	end
  end

  def destroy
  	Post.destroy(params[:id])
  	flash[:notice] = "記事を削除しました。"
  	redirect_to admin_posts_path
  end

  private
  def params_post
    params.require(:post).permit(:user_id, :title, :text, :post_image)
  end

end
