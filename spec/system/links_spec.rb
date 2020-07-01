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
      let!(:user) { create(:user) }
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
      let!(:user) { create(:user) }
      let!(:post) { create(:post, user: user) }
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
          expect(page).to have_link post.title, href: post_path(post)
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

      describe "ログアウト" do
        before do
          visit user_path(user)
        end

        it "ログアウトに成功する" do
          click_link "LogOut"

          expect(page).to have_content "ログアウトしました。"
        end
      end
    end

    context "adminログイン前" do
      describe "header確認" do
        before do
          visit new_admin_session_path
        end
        it "会員登録リンク正しい" do
          expect(page).to have_link "会員登録", href: new_admin_registration_path
        end

        it "ログインリンク正しい" do
          expect(page).to have_link "ログイン", href: new_admin_session_path
        end
      end
    end


    context "admin registration" do
      before do
        visit new_admin_registration_path
      end

      it "管理者登録画面表示される" do
        have_content "管理者登録画面"
      end

      it "admin 新規登録成功する" do
        fill_in "admin[email]", with: "a@a"
        fill_in "admin[password]", with: "aaaaaa"
        fill_in "admin[password_confirmation]", with: "aaaaaa"
        click_button "登録"

        expect(page).to have_content "会員登録が完了しました。"
      end

      it "admin 新規登録失敗する" do
        fill_in "admin[email]", with: ""
        fill_in "admin[password]", with: ""
        fill_in "admin[password_confirmation]", with: ""

        click_button "登録"

        expect(page).to have_content "エラー"
      end
    end

    context "admin ログイン" do
      let(:admin) { create(:admin) }
      before do
        visit new_admin_session_path
      end

      it "admin 管理者ログイン画面表示される" do
        expect(page).to have_content "管理者ログイン"
      end

      it "admin ログイン成功する" do
        fill_in "admin[email]", with: admin.email
        fill_in "admin[password]", with: admin.password

        click_button "ログイン"

        expect(page).to have_content "ログインしました。"
      end

      it "admin ログイン失敗する" do
        fill_in "admin[email]", with: ""
        fill_in "admin[password]", with: ""

        click_button "ログイン"

        expect(page).to have_content "ログインに失敗しました。"
      end

    end

    context "admin ログイン中" do
      let!(:admin) { create(:admin) }
      let!(:user) { create(:user) }
      let!(:post) { create(:post, user: user) }
      before do
        visit new_admin_session_path
        fill_in "admin[email]", with: admin.email
        fill_in "admin[password]", with: admin.password

        click_button "ログイン"
      end
      describe "header確認" do

        it "MyPageリンク正しい" do
          expect(page).to have_link "MyPage", href: admin_admin_path(admin)
        end
        it "会員一覧リンク正しい" do
          expect(page).to have_link "会員一覧", href: admin_users_path
        end
        it "記事一覧リンク正しい" do
          expect(page).to have_link "記事一覧", href: admin_posts_path
        end
        it "タグ一覧リンク正しい" do
          expect(page).to have_link "タグ一覧", href: admin_tags_path
        end
        it "ログアウトリンク正しい" do
          expect(page).to have_link "ログアウト", href: destroy_admin_session_path
        end

      end

      describe "MyPage" do
        before do
          visit admin_admin_path(admin)
        end

        it "MyPage表示される" do
          expect(page).to have_content "MyPage"
        end
        it "編集リンク正しい" do
          expect(page).to have_link "編集", href: edit_admin_admin_path(admin)
        end
      end

      describe "管理者情報編集画面" do
        before do
          visit edit_admin_admin_path(admin)
        end

        it "管理者情報編集画面表示される" do
          expect(page).to have_content "管理者情報編集"
        end
        it "管理者情報編集できる" do
          fill_in "admin[email]", with: "x@x"
          click_button "編集完了"

          expect(page).to have_content "管理者情報を編集しました。"
        end
      end

      describe "会員一覧" do
        before do
          visit admin_users_path
        end
        it "会員一覧表示される" do
          expect(page).to have_content "会員一覧"
        end
      end

      describe "会員詳細情報画面" do
        before do
          visit admin_user_path(user)
        end
        it "会員詳細情報画面表示される" do
          expect(page).to have_content "会員詳細情報"
        end
        it "投稿した記事が表示される" do
          expect(page).to have_content post.title
        end
      end

      describe "会員情報編集" do
        before do
          visit edit_admin_user_path(user)
        end

        it "会員情報編集画面表示される" do
          expect(page).to have_content "会員情報編集"
        end
        it "会員情報編集できる" do
          fill_in "user[email]", with: "b@b"
          click_button "編集完了"

          expect(page).to have_content "会員情報編集しました。"
        end
      end

      describe "記事一覧画面" do
        before do
          visit admin_posts_path
        end

        it "記事一覧画面表示される" do
          expect(page).to have_content "記事一覧"
        end

        it "記事が表示される" do
          expect(page).to have_link post.title, href: admin_post_path(post)
        end

      end

      describe "記事詳細画面" do
        before do
          visit admin_post_path(post)
        end

        it "記事詳細表示される" do
          expect(page).to have_content post.title
        end
        it "記事編集ボタン表示される" do
          expect(page).to have_link "編集"
        end
      end

      describe "記事編集" do
        before do
          visit edit_admin_post_path(post)
        end

        it "記事編集画面表示される" do
          expect(current_path).to eq(edit_admin_post_path(post))
        end
        it "記事編集成功する" do
          fill_in "post[title]", with: "title2"
          fill_in "post[text]", with: "text2"

          click_button "確認画面へ"

          expect(page).to have_content "確認画面"

          click_button "この内容で編集する"

          expect(page).to have_content "記事を編集しました。"
        end
      end

    end

  end
end
