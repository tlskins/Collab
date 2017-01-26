class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :collab_id
      t.integer :creator_id
      t.string :name
      t.boolean :attached
      t.integer :master_start_time
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
