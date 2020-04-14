class AddNamesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lastname, :string, null: false, default: ""
    add_column :users, :lastname_kana, :string, null: false, default: ""
    add_column :users, :firstname, :string, null: false, default: ""
    add_column :users, :firstname_kana, :string, null: false, default: ""
    add_column :users, :nickname, :string, null: false, default: ""
    add_column :users, :image_id, :string
    add_column :users, :status, :boolean, null: false, default: true
  end
end
