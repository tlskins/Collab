class AddBranchIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :branch_id, :integer
  end
end
