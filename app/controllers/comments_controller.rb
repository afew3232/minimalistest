class CommentsController < ApplicationController
  def create
  	@comment_new = Comment.new(params_comment)
  	@comment_new.user_id = current_user.id
  	@comment_new.post_id = params[:post_id]
  	if @comment_new.save(params_comment)
  		@post = Post.find(params[:post_id])
   		@tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
    	@comments = Comment.includes(:user).where(post_id: params[:post_id])
  		render "posts/post_comment"
  	else
  		@post = Post.find(params[:post_id])
   		@tag = Tag.find(LinkTag.where(post_id: @post.id).pluck(:tag_id))
    	@comments = Comment.includes(:user).where(post_id: params[:post_id])
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
  	params.require(:comment).permit(:content)
  end

end
