class AddBranchidToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :branch_id, :integer
  end
end
