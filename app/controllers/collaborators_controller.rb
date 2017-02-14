class CollaboratorsController < ApplicationController

  def new
    @collab_project = CollabProject.find(params[:collab_project_id])
    if current_admin
      @avail_collaborators = Admin.where("id not in (:x)", :x => CollabProject.find_by(id: params[:collab_project_id]).collaborators.admin_ids)
      @collaborator = @collab_project.collaborators.build
    end
  end

  def create
    @collab_project = CollabProject.find(params[:collab_project_id])
    @collaborator = @collab_project.collaborators.new(collaborator_params)
    if @collaborator.save
      flash[:success] = 'Collaborator Added!'
    end

    redirect_to collab_project_path(@collab_project)
  end


  private

  def collaborator_params
    params.require(:collaborator).permit(:admin_id, :collab_id)
  end

end
