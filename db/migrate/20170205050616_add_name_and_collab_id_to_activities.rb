class AddNameAndCollabIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :name, :string
    add_column :activities, :collab_id, :integer
  end
end
