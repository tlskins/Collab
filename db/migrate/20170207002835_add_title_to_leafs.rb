class AddTitleToLeafs < ActiveRecord::Migration
  def change
    add_column :leafs, :title, :string

  end
end
