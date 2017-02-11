class Leaf < ActiveRecord::Base
 include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil }

  belongs_to :branch
  belongs_to :leafable, polymorphic: true, dependent: :destroy
  has_many :comments, as: :commentable

  def add_to_branch(branch_id)
    update_attributes(branch_id: branch_id)
  end

  def update_title(title)
    update_attributes(title: title)
  end

#  def update_link(update_link)
#    if leafable.class == 'SourceYoutube'
#      leafable.update_link(update_link)
#    end
#  end

#  def update_text(update_text)
#    if leafable.class == 'SourceText'
#      leafable.update_text(update_text)
#    end
#  end

end
