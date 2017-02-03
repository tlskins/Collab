class Comment < ActiveRecord::Base
  belongs_to :collaborator
  belongs_to :branch
  acts_as_tree order: 'created_at DESC'

  def add_creator_by_admin(admin_id, collab_id)
    if admin_id and collab_id
      update_attributes(collaborator_id: Collaborator.find_by(collab_id: collab_id, admin_id: admin_id).id)
    end

  end

end
