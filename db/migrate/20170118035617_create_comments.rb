class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :author_id
      t.boolean :pinned
      t.integer :commentary_id
      t.string :commentary_type

      t.timestamps null: false
    end

    add_index :comments, [:commentary_id, :commentary_type]
  end
end
