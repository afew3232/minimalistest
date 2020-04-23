class Post < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :link_tag, dependent: :destroy

	validates :title, presence: true
	validates :text, presence: true

	#carrierwave
	mount_uploader :post_image, PostImageUploader
end
