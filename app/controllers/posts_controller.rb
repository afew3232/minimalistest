class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :confirm_new, :confirm_edit]

  def index
    @post_rank = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))

    #----------呼び出し元(:call)に応じて、対応したデータをPostモデルに代入-----------
    case params[:call]
    when "new" then #新着記事
      @posts = Post.all.order(created_at: "DESC")
      @word = "New Posts"
    when "tag" then #タグ検索
      @posts = Post.find(LinkTag.where(tag_id: params[:tag_id]).pluck(:post_id))
      tag = Tag.find(params[:tag_id])
      @word = tag.name
    when "search" then #検索
      @word = params[:word] #ユーザの入力を@wordへ代入
      @posts = Post.where(["title LIKE ? OR text LIKE ?", "%#{@word}%", "%#{@word}%"])
    else #例外処理
      flash[:danger] = "不正な呼び出し"
      #記事は取得しない
    end

  end

  def show
  	@post = Post.find(params[:id])
    @tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
  end

  def new
  	@post = Post.new
    @tags = Tag.all
  end

  def confirm_new
  	@post = Post.new(params_post)
    @post.user_id = current_user.id
    @tag = Tag.find(params[:tag_id])
  	unless @post.valid? #valid?(有効ですか?) == falseならrender :new
  		render :new
  	end
  end

  def create
  	@post = Post.new(params_post)
    @post.post_image.retrieve_from_cache! params[:cache][:post_image] unless @post.post_image.file.nil?
  	if @post.save
      LinkTag.create(post_id: @post.id, tag_id: params[:tag_id])
  		redirect_to post_path(@post.id)
  	else
  		flash.now[:danger] = "エラーが発生しました。failed to create."
  		render :confirm_new
  	end
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
  		redirect_to post_path(@post.id)
  	else
  		flash.now[:danger] = "エラーが発生しました。failed to update."
  		render :confirm_edit
  	end
  end

  private
  def params_post
  	params.require(:post).permit(:user_id, :title, :text, :post_image)
  end

end
