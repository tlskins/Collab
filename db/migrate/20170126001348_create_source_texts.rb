class CreateSourceTexts < ActiveRecord::Migration
  def change
    create_table :source_texts do |t|
      t.string :text
      t.string :title

      t.timestamps null: false
    end
  end
end
