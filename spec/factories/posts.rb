FactoryBot.define do
	factory :post do
		title { "title1" }
		text { "text1" }
		user
	end
end