class CreateSourceTypes < ActiveRecord::Migration
  def change
    create_table :source_types do |t|
      t.string :source_type

      t.timestamps null: false
    end
  end
end
