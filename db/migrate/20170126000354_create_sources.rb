class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.integer :source_id
      t.string :source_type
      t.integer :leaf_id

      t.timestamps null: false
    end

    add_index :sources, [:source_type, :source_id]
  end
end
