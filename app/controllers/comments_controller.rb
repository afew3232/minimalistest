class CommentsController < ApplicationController
  def create
  	@comment_new = Comment.new(params_comment)
    @comment_new.score = Language.get_data(params_comment[:content])
    @post = Post.find(params[:post_id])
    @tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
    @comments = Comment.includes(:user).where(post_id: params[:post_id])
  	if @comment_new.save
  		render "posts/post_comment"
  	else
  		render "posts/show"
  	end
  end

  def destroy
  	Comment.destroy(params[:comment_id])
  	@comment_new = Comment.new
  	@post = Post.find(params[:post_id])
   	@tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
    @comments = Comment.includes(:user).where(post_id: params[:post_id])
    render "posts/post_comment"
  end

  private
  def params_comment
  	params.require(:comment).permit(:content).merge(user_id: current_user.id, post_id: params[:post_id])
  end

end
