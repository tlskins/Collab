class ChangeBranchNameBack < ActiveRecord::Migration
  def change
    rename_table :branch, :branches
  end
end
