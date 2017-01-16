class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :admin_id
      t.integer :collab_id

      t.timestamps null: false
    end
  end
end
