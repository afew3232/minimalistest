class HomeController < ApplicationController
  def top
  	@posts = Post.all.order(created_at: "DESC").limit(5)
    @post_rank = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))
  end

  def about
  end
end
