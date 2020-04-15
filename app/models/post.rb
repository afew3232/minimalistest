class Post < ApplicationRecord
	validates :title, presence: true
	validates :text, presence: true

	attachment :image
end
