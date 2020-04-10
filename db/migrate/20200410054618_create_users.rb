class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :firstname_kana
      t.string :lastname_kana
      t.string :email
      t.string :nickname
      t.string :image_id
      t.boolean :status

      t.timestamps
    end
  end
end
