class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :text
      t.text :merit
      t.text :demerit

      t.timestamps
    end
  end
end
