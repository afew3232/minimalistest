require 'rails_helper'

describe 'user header test', type: :system do
  describe 'links' do
    context 'ログイン前、header確認' do
      before do
        visit root_path
      end
      it 'logoリンクが正しい' do
        expect(page).to have_link 'Minimalistest', href: root_path
      end
      it 'Showリンクが正しい' do
        expect(page).to have_link 'New Posts', href: posts_path
      end
      it 'Tagリンク正しい' do
        expect(page).to have_content 'Tag'
      end
      it 'Searchリンク正しい' do
        expect(page).to have_content 'Search'
      end
      it 'LogInリンク正しい' do
        expect(page).to have_link 'LogIn', href: new_user_session_path
      end
      it '会員登録リンク正しい' do
        expect(page).to have_link '会員登録', href: new_user_registration_path
      end
    end

    context "user registration" do
      before do
        visit new_user_registration_path
      end
      it "新規登録に成功する" do
        fill_in "user[email]", with: "a@a"
        fill_in "user[password]", with: "aaaaaa"
        fill_in "user[password_confirmation]", with: "aaaaaa"
        fill_in "user[nickname]", with: "aaa"
        fill_in "user[lastname]", with: "山田"
        fill_in "user[firstname]", with: "武"
        fill_in "user[lastname_kana]", with: "ヤマダ"
        fill_in "user[firstname_kana]", with: "タケシ"
        click_button "会員登録"

        expect(page).to have_content "会員登録が完了しました。"
      end
      it "新規登録に失敗する" do
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        fill_in "user[password_confirmation]", with: ""
        fill_in "user[nickname]", with: ""
        fill_in "user[lastname]", with: ""
        fill_in "user[firstname]", with: ""
        fill_in "user[lastname_kana]", with: ""
        fill_in "user[firstname_kana]", with: ""
        click_button "会員登録"

        expect(page).to have_content "エラー"
      end
      it "ログイン画面へリンク" do
        expect(page).to have_link "ログイン", href: new_user_session_path
      end
    end

    describe "user login" do
      #factroy_bot factries/users.rbよりデータ参照
      let(:user) { create(:user) }
      before do
        visit new_user_session_path
      end

      context "ログイン画面に遷移" do
        let(:test_user) { user }
        it "ログインに成功する" do
          fill_in "user[email]", with: test_user.email
          fill_in "user[password]", with: test_user.password
          click_button "ログイン"

          expect(page).to have_content "ログインしました。"
        end
        it "ログインに失敗する" do
          fill_in "user[email]", with: ""
          fill_in "user[password]", with: ""

          expect(current_path).to eq(new_user_session_path)
        end

        it "会員登録画面へリンク" do
          expect(page).to have_link "会員登録", href: new_user_registration_path
        end
      end
    end

    describe "ログイン中" do
      let(:user) { create(:user) }
      let(:post) { create(:post, user: user) }
      before do
        visit new_user_session_path
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "ログイン"
      end

      describe "header確認" do
        it "New Posts表示" do
          expect(page).to have_link "New Posts", href: posts_path
        end
        it "Tag表示" do
          expect(page).to have_content "Tag"
        end
        it "Write a post表示" do
          expect(page).to have_link "Write a post", href: new_post_path
        end
        it "MyPage表示" do
          expect(page).to have_link "MyPage", href: user_path(user.id)
        end
        it "Search表示" do
          expect(page).to have_content "Search"
        end
        it "LogOut表示" do
          expect(page).to have_link "LogOut", href: destroy_user_session_path
        end
      end

      describe "新しい記事投稿" do
        before do
          visit new_post_path
        end

        it "新しい記事投稿に成功する" do
          fill_in "post[title]", with: "title"
          fill_in "post[text]", with: "text"
          click_button "確認画面へ"

          expect(page).to have_content "確認画面"
          click_button "この内容で投稿する"

          expect(page).to have_content "記事を投稿しました。"
        end

      end

      describe "マイページ" do
        before do
          visit user_path(user)
        end

        it "マイページが表示される" do
          expect(page).to have_content "ユーザー情報"
        end
        it "編集画面へのリンク" do
          expect(page).to have_link "編集", href: edit_user_path(user)
        end
        it "投稿記事表示" do
          expect(page).to have_content post.title
        end

      end

      describe "ユーザー情報 編集" do
        before do
          visit edit_user_path(user)
        end

        it "ユーザー編集画面が表示される" do
          expect(page).to have_content "会員情報編集"
        end
        it "ユーザー編集できる" do
          fill_in "user[email]", with: "b@b"
          click_button "編集完了"

          expect(page).to have_content "会員情報を変更しました。"
        end
      end

      describe "記事編集" do
        before do
            visit edit_post_path(post)
        end

        it "記事編集画面が表示される" do
            expect(page).to have_content "記事編集"
        end
        it "記事編集に成功する" do
          fill_in "post[title]", with: "titleedit"
          fill_in "post[text]", with: "textedit"
          click_button "確認画面へ"

          expect(page).to have_content "確認画面"
          click_button "この内容で編集する"

          expect(page).to have_content "記事を編集しました。"
        end
      end

    end
  end
end
