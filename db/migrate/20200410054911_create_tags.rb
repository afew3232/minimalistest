class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.integer :post_id
      t.string :name, null: false

      t.timestamps
    end
  end
end
