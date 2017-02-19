class AddPrivateToCollab < ActiveRecord::Migration
  def change
    add_column :collab_projects, :private, :boolean
  end
end
