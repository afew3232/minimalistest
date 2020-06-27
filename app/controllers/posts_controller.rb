class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :confirm_new, :confirm_edit]

  include TagMaxConcern
  before_action :set_tag_max #concernで @TAGMAX(tagの最大値の定数)を作成する

  def index
    @post_rank = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))

    #----------呼び出し元(:call)に応じて、対応したデータをPostモデルに代入-----------
    case params[:call]
    when "tag" then #タグ検索
      @posts = Post.find(LinkTag.where(tag_id: params[:tag_id]).pluck(:post_id))
      tag = Tag.find(params[:tag_id])
      @word = tag.name
    when "search" then #検索
      @word = params[:word] #ユーザの入力を@wordへ代入
      @posts = Post.where(["title LIKE ? OR text LIKE ?", "%#{@word}%", "%#{@word}%"])
    else #指定なければ新着記事
      @posts = Post.all.order(created_at: "DESC")
      @word = "New Posts"
    end

  end

  def show
  	@post = Post.find(params[:id])
    @tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
    @comments = Comment.includes(:user).where(post_id: params[:id])
    @comment_new = Comment.new
  end

  def new
  	@post = Post.new
    @tags = Tag.all
    @tag = []
  end

  def confirm_new
  	@post = Post.new(params_post)
    @post.user_id = current_user.id
   	@tag = []
    for i in 0..@TAGMAX do
      @tag.push(Tag.find(params[:tag_id[i]])) unless params[:tag_id[i]] == ""
    end
    render :new if @post.invalid?
  end

  def create
  	@post = Post.new(params_post)
    # 画像がない　→　params[:cache][:post_image] == "" になる。
    @post.post_image.retrieve_from_cache! params[:cache][:post_image] unless params[:cache][:post_image]==""
  	if @post.save
      for i in 0..@TAGMAX do
        LinkTag.create(post_id: @post.id, tag_id: params[:tag_id[i]]) if params[:tag_id[i]]
      end
  		redirect_to post_path(@post.id), flash: {success: "記事を投稿しました。"}
  	else
  		flash.now[:danger] = "エラーが発生しました。failed to create."
  		render :confirm_new
  	end
  end

  def edit
  	@post = Post.find(params[:id])
    @post.post_image.cache! unless @post.post_image.blank?
    @tags = Tag.all
    @tag = Tag.where(id: LinkTag.where(post_id: @post.id).pluck(:tag_id))
  end

  def confirm_edit
  	@post = Post.new(params_post)
  	@post.id = params[:id]
    @tag = []
    for i in 0..@TAGMAX do
      @tag.push(Tag.find(params[:tag_id[i]])) unless params[:tag_id[i]] == ""
  	end
    render :edit if @post.invalid?
  end

  def update
  	@post = Post.find(params[:id])
    @post.update_columns(post_image: nil)
    @post.post_image.retrieve_from_cache! params[:cache][:post_image] unless params[:cache][:post_image]==""
  	if @post.update(params_post)
      @post.link_tag.destroy_all #updateした@postに関連付けされているLinkTagをすべて削除
      for i in 0..@TAGMAX do
        LinkTag.create(post_id: @post.id, tag_id: params[:tag_id[i]]) if params[:tag_id[i]]
      end
  		redirect_to post_path(@post.id), flash: {success: "記事を編集しました。"}
  	else
  		flash.now[:danger] = "エラーが発生しました。failed to update."
  		render :confirm_edit
  	end
  end

  def destroy
    Post.destroy(params[:id])
    flash[:success] = "記事を削除しました。"
    redirect_to user_path(current_user.id)
  end

  private
  def params_post
  	params.require(:post).permit(:user_id, :title, :text, :post_image, :post_image_cache)
  end

end
