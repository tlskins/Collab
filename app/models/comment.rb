class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.controller_current_admin ? controller.controller_current_admin : nil },
        name: Proc.new { |controller, model| model.commentable.class.to_s + ' ' + (model.commentable.name ? model.commentable.name : model.commentable.title) },
        collab_id: Proc.new { |controller, model| model.collab_id },
        collab_name: Proc.new { |controller, model| model.collab_name }

  belongs_to :collaborator
  #belongs_to :branch
  belongs_to :commentable, polymorphic: true

  acts_as_tree order: 'created_at DESC'

  def add_creator_by_admin(admin_id, collab_id)
    if admin_id and collab_id
      update_attributes(collaborator_id: Collaborator.find_by(collab_id: collab_id, admin_id: admin_id).id)
    end
  end

  def collab_id
    if commentable.class.to_s == 'Branch'
      return commentable.collab_id
    elsif commentable.class.to_s == 'Leaf'
      return commentable.branch.collab_id
    elsif commentable.class.to_s == 'CollabProject'
      return commentable.id
    end
  end

  def collab_name
    if commentable.class.to_s == 'Branch'
      return commentable.collabproject.name
    elsif commentable.class.to_s == 'Leaf'
      return commentable.branch.collabproject.name
    elsif commentable.class.to_s == 'CollabProject'
      return commentable.name
    end
  end

end
