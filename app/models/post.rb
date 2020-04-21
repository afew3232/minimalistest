class Post < ApplicationRecord
	validates :title, presence: true
	validates :text, presence: true

	#carrierwave
	mount_uploader :post_image, PostImageUploader
end
