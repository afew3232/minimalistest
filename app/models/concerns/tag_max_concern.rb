module TagMaxConcern
	extend ActiveSupport::Concern

	def set_tag_max
		@TAGMAX = 2 #postのタグの最大個数-1 (最大1個→0)
	end
end