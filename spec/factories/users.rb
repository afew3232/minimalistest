FactoryBot.define do
	factory :user do
		email { "a@a" }
		password { "aaaaaa" }
		nickname { "aaa" }
		lastname { "山田" }
		firstname { "太郎" }
		lastname_kana { "ヤマダ" }
		firstname_kana { "タロウ" }
		posts {[
     		FactoryBot.build(:post, user: nil)
    	]}
	end
end