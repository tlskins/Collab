class UpdateLeafArchitecture < ActiveRecord::Migration
  def change
    remove_column :leafs, :source_id, :integer
    remove_column :leafs, :source_type, :string
    add_column :source_youtubes, :leaf_id, :integer
    add_column :source_texts, :leaf_id, :integer
    drop_table :source_types
  end
end
