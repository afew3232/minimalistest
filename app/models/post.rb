class Post < ApplicationRecord
	belongs_to :user
	has_many :tags
	has_many :favorites

	validates :title, presence: true
	validates :text, presence: true

	#carrierwave
	mount_uploader :post_image, PostImageUploader
end
