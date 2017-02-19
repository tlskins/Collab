class BranchesController < ApplicationController
  include CollaboratorHelper
  include PublicActivityHelper
  before_action :check_project_privacy, only: [:show]
  before_action :check_is_collaborator, only: [:update, :destroy, :new, :create]
  before_action :load_activities, only: [:show, :new, :edit]

  def new
    @branch = Branch.new
    if params[:branch_id]
      @parent_branch = Branch.find_by(id: params[:branch_id])
    end 
  end

  def create
    collab_project = CollabProject.find(params[:collab_project_id])
    @branch = collab_project.branches.new(name: params[:branch][:name], purpose: params[:branch][:purpose], creator_id: Collaborator.find_by(admin_id: current_admin.id, collab_id: collab_project.id).id, parent_id: params[:branch_id])
    if @branch.save
      flash[:notice] = "Successfully created Branch!"
      redirect_to collab_project_branch_path(@branch.collabproject, @branch)
    else
      flash[:alert] = "Error creating new Branch!"
      render :new
    end
  end

  def update
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(branch_params)
      flash[:success] = "Successfully updated Branch!"
    else
      flash[:alert] = "Error updating Branch!"
    end
    redirect_to collab_project_branch_path(@branch.collabproject, @branch)
  end

  def show
    puts 'begin branch#show controller'
    @branch = Branch.find(params[:id])
    @parent_branch = @branch.parent_branch
    @collab_project = @branch.collabproject

    # Leaf derivations
    @current_page = params[:page].to_i
    (@current_page = 1) if @current_page == 0
    @leaf_count = @branch.leaves.count
    @leaf_count == 0 ? @all_leaves = nil : @all_leaves = @branch.leaves.order('created_at DESC').includes(:leafable, :branch, { comments: {collaborator: :admin} } ).leaf_paginate(@current_page, 5)
    if  @leaf_count == 0
      @active_leaf = nil
    elsif params[:active_leaf] 
      @active_leaf = Leaf.find(params[:active_leaf])
    else
      @active_leaf = @all_leaves.first
    end
    @pages = (@leaf_count / 5.to_f).ceil

    @branch.child_branches ? @child_branches = @branch.child_branches : @child_branches = nil
    @branch_comments = @branch.comments.limit(25).includes(collaborator: [:admin]).hash_tree

    # New object preparation
    @leaf = Branch.find(params[:id]).leaves.new
    @video_upload = VideoUpload.new
    @source_youtube = SourceYoutube.new
    @source_text = SourceText.new
    @new_comment = Comment.new

    # Determine if user is a collaborator now to avoid this call in the view
    @is_current_admin_collaborator = current_admin_collaborator?(@collab_project.id)
  end

  def destroy
    branch = Branch.find(params[:id])
    parent = branch.parent_branch
    parent ||= branch.collabproject
    if current_admin == branch.creator.admin or current_admin == branch.collabproject.creator.admin
      branch.destroy
      flash[:success] = "Branch deleted"
    end
    if parent.class.name == 'Branch'
      redirect_to collab_project_branch_path(parent.collabproject, parent)
    elsif parent.class.name == 'CollabProject'
      redirect_to collab_project_path(parent)
    end
  end

  private

  def branch_params
    params.require(:branch).permit(:name, :purpose, :order)
  end

  def load_activities
    if current_admin
      relevent_activities = PublicActivity::Activity.where("collab_id in (:x)", :x => current_admin.collaborators.collab_ids).order('created_at DESC').limit(20).includes(:owner, :trackable)
      load_activities_hash( relevent_activities )
    end
  end

  def check_project_privacy
    if !(current_admin_collaborator?(Branch.find(params[:id]).collabproject.id)) and Branch.find(params[:id]).collabproject.private == true
      flash[:danger] = "Cannot access that project"
      redirect_to root_path
    end
  end

  def check_is_collaborator
    if !(current_admin_collaborator?(params[:collab_project_id]))
      flash[:danger] = "You do not have access for that"
      redirect_to root_path
    end
  end

end
