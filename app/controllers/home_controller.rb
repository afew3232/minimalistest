class HomeController < ApplicationController
  def top
  	#無効なユーザー(退会)を強制ログアウト
  	if user_signed_in?
  		if User.find(current_user.id).status == false
        flash[:notice] = "ログインに失敗しました。退会済みのユーザーです。"
  			sign_out_and_redirect(current_user)
  		end
  	end

  	@posts = Post.all.order(created_at: "DESC").limit(5)
    @post_rank = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))
    @post_recommended = Post.find(Comment.group(:post_id).sum(:score).sort_by{|k,v| v}.reverse.to_h.keys.first(5))
    #ポストのコメントのスコア(google apiでコメントcreate時に作成)の合計で降順ソート
  end

  def about
  end
end
