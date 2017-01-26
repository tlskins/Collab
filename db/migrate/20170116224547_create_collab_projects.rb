class CreateCollabProjects < ActiveRecord::Migration
  def change
    create_table :collab_projects do |t|
      t.string :name
      t.string :description
      t.integer :creator_id

      t.timestamps null: false
    end
  end
end
