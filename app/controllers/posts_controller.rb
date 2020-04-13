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
  end

  def create
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
