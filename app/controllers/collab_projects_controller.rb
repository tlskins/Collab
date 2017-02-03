class CollabProjectsController < ApplicationController

  def index
    if current_admin
      @collab_projects = CollabProject.where(id: Collaborator.where(admin_id: current_admin.id).pluck(:collab_id))
      @collab_projects_all = CollabProject.where.not(id: Collaborator.where(admin_id: current_admin.id).pluck(:collab_id))
    else
      @collab_projects_all = CollabProject.all
      @collab_projects = []
    end
  end

  def new
    puts 'collabproj controller new called'
    @collab_project = CollabProject.new
  end

  def create
    @collab_project = CollabProject.new(collab_project_params)
    if @collab_project.save
      @collab_project.add_creator(current_admin)
      flash[:notice] = "Successfully created Collab!"
      redirect_to collab_project_path(@collab_project)
    else
      flash[:alert] = "Error creating new Collab!"
      render :new
    end
  end

  def show
    @collab_project = CollabProject.find(params[:id])
    @collaborators_list = @collab_project.list_collaborators
    @branches = @collab_project.branches.where(parent_id: nil)
  end

  private

  def collab_project_params
    params.require(:collab_project).permit(:name, :description)
  end

end
