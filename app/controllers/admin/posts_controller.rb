class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :show, :edit, :confirm_edit, :update, :destroy]
  def index
    @posts = Post.all.includes(:user) #N+1回避
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
    #画像データがnilでなければ、confirm_editのviewから送られてきた画像データ(cache内)を@post.post_imageに代入
    @post.post_image.retrieve_from_cache! params[:cache][:post_image] unless @post.post_image.file.nil?
  	if @post.update(params_post)
      @post.link_tag.destroy_all #updateした@postに関連付けされているLinkTagを一度すべて削除
      LinkTag.create(post_id: @post.id, tag_id: params[:tag_id]) #LinkTag再生成
  		redirect_to admin_post_path(@post.id)
  	else
  		flash.now[:danger] = "エラーが発生しました。failed to update."
  		render :confirm_edit
  	end
  end

  def destroy
  	Post.destroy(params[:id])
  	flash[:success] = "記事を削除しました。"
  	redirect_to admin_posts_path
  end

  private
  def params_post
    params.require(:post).permit(:user_id, :title, :text, :post_image)
  end

end
