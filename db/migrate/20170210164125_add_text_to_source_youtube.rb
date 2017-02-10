class AddTextToSourceYoutube < ActiveRecord::Migration
  def change
    add_column :source_youtubes, :text, :string
  end
end
