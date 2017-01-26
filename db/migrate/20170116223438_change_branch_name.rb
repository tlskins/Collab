class ChangeBranchName < ActiveRecord::Migration
  def change
    rename_table :branches , :branch
  end
end
