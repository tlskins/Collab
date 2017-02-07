class AddPolymorphicToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :leafable_id, :integer
    add_column :leafs, :leafable_type, :string
    remove_column :source_youtubes, :leaf_id, :integer
    remove_column :source_texts, :leaf_id, :integer

  end
end
