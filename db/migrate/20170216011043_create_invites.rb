class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :collab_id
      t.string :name
      t.string :email
      t.string :invite_token
      t.string :message

      t.timestamps null: false
    end
  end
end
