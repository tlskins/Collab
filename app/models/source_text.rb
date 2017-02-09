class SourceText < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil },
        name: Proc.new { |controller, model| model.leaf ? model.leaf.branch.name : nil },
        collab_id: Proc.new { |controller, model| model.leaf ? model.leaf.branch.collab_id : nil},
        collab_name: Proc.new { |controller, model| model.leaf ?  model.leaf.branch.collabproject.name : nil }
  has_one :leaf, as: :leafable
  validates :text, presence: true

  def update_text(update_text)
    update_attributes(text: update_text)
  end

  def text_html
    text.to_s.gsub(/\n/, '<br/>').html_safe
  end

end
