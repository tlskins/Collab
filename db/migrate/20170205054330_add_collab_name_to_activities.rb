class AddCollabNameToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :collab_name, :string

  end
end
