class PostsController < ApplicationController
  def index
  	@posts = Post.all
  end

  def show
  end

  def new
  	@post = Post.new
  end

  def confirm_new
  	@post = Post.new(params_post)
  	unless @post.valid? #valid?(有効?) == falseならrender :new
  		render :new
  	end
  end

  def create
  	@post = Post.new(params_post)
  	if @post.save
  		redirect_to post_path(@post.id)
  	else
  		flash[:notice] = "エラーが発生しました。"
  		render :confirm_new
  	end
  end

  def edit
  end

  def confirm_edit
  end

  def update
  end

  private
  def params_post
  	params.require(:post).permit(:title, :text)
  end

end
