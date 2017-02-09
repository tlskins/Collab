class Branch < ActiveRecord::Base
  include PublicActivity::Model
  before_save :write_branch_path
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil },
	name: Proc.new { |controller, model| model.name },
        collab_id: Proc.new { |controller, model| model.collab_id },
        collab_name: Proc.new { |controller, model| model.collabproject.name }

  belongs_to :collabproject, class_name: "CollabProject", foreign_key: :collab_id
  belongs_to :creator, class_name: "Collaborator", foreign_key: :creator_id
  belongs_to :parent_branch, class_name: "Branch", foreign_key: :parent_id
  has_many :child_branches, class_name: "Branch", foreign_key: :parent_id, dependent: :destroy
  has_many :leaves, class_name: "Leaf", dependent: :destroy
  has_many :comments

  def add_creator(admin)
    collaborator = Collaborator.find_by(admin_id: admin.id, collab_id: collabproject.id)
    update_attributes(creator_id: collaborator.id)
  end

  def add_parent_branch(branch)
    unless self.parent_branch
      update_attributes(parent_id: branch.id)
    end
  end

  def purpose_html
    purpose.to_s.gsub(/\n/, '<br/>').html_safe
  end

  private

  def write_branch_path
    if parent_branch
      if parent_branch.path
	# Root second+ generation branches append parent name with parent path
        self.path = parent_branch.path + parent_branch.name + '/'
      else
        # A Root branches first child pulls path from parent branch's name
        self.path = parent_branch.name + '/'
      end
    # Root branch has no path
    else
      self.path = nil
    end
  end

end
