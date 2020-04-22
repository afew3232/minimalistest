module FavoritesHelper

  #いいねされてるかどうか判別するメソッド
	#戻り値  いいねされてる:true  いいねされてない:false
	def favorited?(favorite_user_id,favorite_post_id)
 		favorites = Favorite.all
 		favorites.each do |l|
 		 	if favorite_user_id == l.user_id && favorite_post_id == l.post_id
 				return true
     	end
  	end
    return false
  end

  #いいねの数を数えて返す
  #戻り値  いいねされてる数
  def favorited_count(favorited_post_id)
    favorite = Favorite.all
    count = 0
    favorite.each do |l|
    	if l.post_id == favorited_post_id
     			count = count + 1
    	end
    end
    return count
  end

end
