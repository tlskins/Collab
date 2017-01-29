class CollabProjectsController < ApplicationController

  def index
    if current_admin
      @collab_projects = CollabProject.find_by_admin(current_admin)
    else
      @collab_projects = CollabProject.all
    end
  end

  def new
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
