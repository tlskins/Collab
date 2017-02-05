class SourceYoutube < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil },
        name: Proc.new { |controller, model| model.leaf.branch.name },
        collab_id: Proc.new { |controller, model| model.leaf.branch.collab_id },
        collab_name: Proc.new { |controller, model| model.leaf.branch.collabproject.name }

  belongs_to :leaf
  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
  validates :link, presence: true, format: YT_LINK_FORMAT

  def update_link(update_link)
    update_attributes(link: update_link)
  end

end
