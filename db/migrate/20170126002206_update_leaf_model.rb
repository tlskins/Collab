class UpdateLeafModel < ActiveRecord::Migration
  def change
    add_column :leafs, :name, :string
    add_column :leafs, :creator_id, :integer
    add_column :leafs, :order, :integer
    add_column :leafs, :source_id, :integer
    remove_column :leafs, :link, :string
    remove_column :leafs, :title, :string
    remove_column :leafs, :published_at, :datetime
    remove_column :leafs, :likes, :integer
    remove_column :leafs, :dislikes, :integer
    remove_column :leafs, :uid, :string
    remove_column :leafs, :description, :string
    remove_column :leafs, :length, :integer
  end
end
