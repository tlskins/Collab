class AddDescriptionToBranch < ActiveRecord::Migration
  def change
    add_column :branch, :description, :string
  end
end
