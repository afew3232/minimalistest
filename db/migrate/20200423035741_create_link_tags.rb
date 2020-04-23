class CreateLinkTags < ActiveRecord::Migration[5.2]
  def change
    create_table :link_tags do |t|
      t.integer :post_id, foreign_key: true
      t.integer :tag_id, foreign_key: true

      t.timestamps
    end
  end
end
