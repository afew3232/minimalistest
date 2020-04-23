class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all.includes(:user)
  end

  def show
  	@post = Post.find(params[:id])
    @tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
  end

  def edit
  	@post = Post.find(params[:id])
    @tags = Tag.all
    @tag = Tag.find(LinkTag.find_by(post_id: @post.id).tag_id)
  end

  def confirm_edit
    @post = Post.new(params_post)
    @post.id = params[:id]
    @tag = Tag.find(params[:tag_id])
  	unless @post.valid? #valid?(有効ですか?) == falseならrender :new
  		render :edit
  	end
  end

  def update
  	@post = Post.find(params[:id])
    @post.post_image.retrieve_from_cache! params[:cache][:post_image] unless @post.post_image.file.nil?
  	if @post.update(params_post)
      @post.link_tag.destroy_all #updateした@postに関連付けされているLinkTagをすべて削除
      LinkTag.create(post_id: @post.id, tag_id: params[:tag_id])
  		redirect_to admin_post_path(@post.id)
  	else
  		flash.now[:danger] = "エラーが発生しました。failed to update."
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
