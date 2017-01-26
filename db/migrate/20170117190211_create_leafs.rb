class CreateLeafs < ActiveRecord::Migration
  def change
    create_table :leafs do |t|
      t.string :link
      t.string :title
      t.datetime :published_at
      t.integer :likes
      t.integer :dislikes
      t.string :uid
      t.string :description
      t.integer :length

      t.timestamps null: false
    end
    add_index :leafs, :uid
  end
end
