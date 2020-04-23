class Tag < ApplicationRecord
	has_many :link_tag, dependent: :destroy

	validates :name, presence: true
end
