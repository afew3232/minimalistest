class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :text
      t.string :merit, array: true
      t.string :demerit, array: true

      t.timestamps
    end
  end
end
