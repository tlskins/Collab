class SourceText < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil },
        name: Proc.new { |controller, model| model.leaf.branch.name },
        collab_id: Proc.new { |controller, model| model.leaf.branch.collab_id },
        collab_name: Proc.new { |controller, model| model.leaf.branch.collabproject.name }

  belongs_to :leaf
  #validates :title, presence: true, length: {maximum: 140}
  validates :text, presence: true

  def update_text(update_text)
    update_attributes(text: update_text)
  end

end
