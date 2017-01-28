class AddActiveToSourceTypeModel < ActiveRecord::Migration
  def change
    add_column :source_types, :active, :bolean

  end
end
