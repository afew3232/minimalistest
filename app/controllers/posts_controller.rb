class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :confirm_new, :confirm_edit]

  def index
    @posts = Post.all.order(created_at: "DESC")
    @post_rank = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))
  end

  def show
  	@post = Post.find(params[:id])
  end

  def new
  	@post = Post.new
  end

  def confirm_new
  	@post = Post.new(params_post)
  	unless @post.valid? #valid?(有効ですか?) == falseならrender :new
  		render :new
  	end
  end

  def create
  	@post = Post.new(params_post)
    @post.post_image.retrieve_from_cache! params[:cache][:post_image]
  	if @post.save
  		redirect_to post_path(@post.id)
  	else
  		flash[:notice] = "エラーが発生しました。failed to create."
  		render :confirm_new
  	end
  end

  def edit
  	@post = Post.find(params[:id])
  end

  def confirm_edit
  	@post = Post.new(params_post)
  	@post.id = params[:id]
  	unless @post.valid? #valid?(有効ですか?) == falseならrender :new
  		render :edit
  	end
  end

  def update
  	@post = Post.find(params[:id])
    @post.post_image.retrieve_from_cache! params[:cache][:post_image]
  	if @post.update(params_post)
  		redirect_to post_path(@post.id)
  	else
  		flash[:notice] = "エラーが発生しました。failed to update."
  		render :confirm_edit
  	end
  end

  private
  def params_post
  	params.require(:post).permit(:user_id, :title, :text, :post_image)
  end

end
