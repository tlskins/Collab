class ModifyBranchesModel < ActiveRecord::Migration
  def change
    remove_column :branches, :attached, :boolean
    remove_column :branches, :master_start_time, :integer
    remove_column :branches, :description, :string
    add_column :branches, :purpose, :string
    add_column :branches, :order, :integer
  end
end
