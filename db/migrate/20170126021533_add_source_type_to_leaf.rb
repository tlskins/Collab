class AddSourceTypeToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :source_type, :string
  end
end
