class FavoritesController < ApplicationController
	before_action :authenticate_user!, only: [:create, :destroy]

	def create
		Favorite.create(post_id: params[:post_id], user_id: params[:user_id])
		@post = Post.find(params[:post_id])
		render 'posts/post_favorite'
	end

	def destroy
		favorite = Favorite.find_by(post_id: params[:post_id], user_id: params[:user_id])
		favorite.delete
		@post = Post.find(params[:post_id])
		render 'posts/post_favorite'
	end

end
