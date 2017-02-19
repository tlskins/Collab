module CollaboratorHelper

  def current_admin_collaborator?(collab_id)
    puts 'call current_admin_collaborator?'
    if current_admin and collab_id
      return CollabProject.find_by(id: collab_id).collaborators.pluck('admin_id').include?( current_admin.id )
    else
      return false
    end
  end

end
