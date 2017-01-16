class AddYtAccessToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string
    add_column :admins, :token, :string
    add_column :admins, :uid, :string
    add_index :admins, :uid, unique: true
  end
end
