class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil },
        name: Proc.new { |controller, model| model.branch.name },
        collab_id: Proc.new { |controller, model| model.branch.collab_id },
        collab_name: Proc.new { |controller, model| model.branch.collabproject.name }

  belongs_to :collaborator
  belongs_to :branch

  acts_as_tree order: 'created_at DESC'

  def add_creator_by_admin(admin_id, collab_id)
    if admin_id and collab_id
      update_attributes(collaborator_id: Collaborator.find_by(collab_id: collab_id, admin_id: admin_id).id)
    end

  end

end
