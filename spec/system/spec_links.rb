require 'rails_helper'

RSpec.describe "links", type: :request do
	describe "会員画面 ログイン前" do

		before do
			get root_path
		end
		context "TOP画面が表示される" do
			it "response.status 200" do
				expect(response.status).to eq 200
			end
            it 'タイトルが正しく表示されていること' do
                expect(response.body).to include("Minimalistest")
            end
 		end
 		context "Headerの表示確認" do
            it 'Headerが正しく表示されていること' do
                expect(response.body).to include("Minimalistest")
                expect(response.body).to include("New Posts")
                expect(response.body).to include("Tag")
                expect(response.body).to include("Search")
                expect(response.body).to include("LogIn")
                expect(response.body).to include("会員登録")
            end
 		end
 		context "Header リンクの確認" do
		  it '各リンク表示される' do
	    	expect(response.page).to have_link 'New Posts', href: posts_path
		  end
		end

	end
end