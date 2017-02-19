class CollabProjectsController < ApplicationController
  before_action :load_activities, only: [:index, :show, :new]
  before_action :check_project_privacy, only: [:show, :update, :destroy]
  before_action :check_is_signed_in, only: [:new, :create]
  include PublicActivityHelper
  include CollaboratorHelper

  def index
    if current_admin
      @collab_projects = CollabProject.where(id: Collaborator.where(admin_id: current_admin.id).pluck(:collab_id))
      @collab_projects_all = CollabProject.where.not(id: Collaborator.where(admin_id: current_admin.id).pluck(:collab_id))
    else
      @collab_projects_all = CollabProject.where(private: [nil,false])
      @collab_projects = []
    end
  end

  def new
    @collab_project = CollabProject.new
  end

  def update
    @collab_project = CollabProject.find(params[:id])
    if @collab_project.update_attributes(collab_project_params)
      flash[:success] = "Successfully updated Collab!"
    else
      flash[:alert] = "Error updating Collab!"
    end
    redirect_to collab_project_path(@collab_project)
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
    @branches = @collab_project.branches.where(parent_id: nil).order('created_at ASC')
    @new_comment = Comment.new
    @collab_comments = @collab_project.comments.limit(18).includes(collaborator: [:admin]).hash_tree
    @is_current_admin_collaborator = current_admin_collaborator?(@collab_project.id)
  end

  def destroy
    collab = CollabProject.find(params[:id])
    if current_admin == collab.creator.admin
      collab.destroy
      flash[:success] = "Collab deleted"
    end
    redirect_to root_path
  end

  private

  def collab_project_params
    params.require(:collab_project).permit(:name, :description, :private)
  end

  def load_activities
    if current_admin
      relevent_activities = PublicActivity::Activity.where("collab_id in (:x)", :x => current_admin.collaborators.collab_ids).order('created_at DESC').limit(20).includes(:owner, :trackable) 
      load_activities_hash( relevent_activities )
    end
  end

  def check_project_privacy
    if !(current_admin_collaborator?(params[:id])) and CollabProject.find(params[:id]).private == true
      flash[:danger] = "Cannot access that project"
      redirect_to root_path
    end
  end

  def check_is_signed_in
    if !(current_admin)
      flash[:danger] = "You do not have access for that"
      redirect_to root_path
    end
  end

end
