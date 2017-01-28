class DropSources < ActiveRecord::Migration
  def change
    drop_table :sources
  end
end
