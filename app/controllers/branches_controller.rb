class BranchesController < ApplicationController
  include CollaboratorHelper
  include PublicActivityHelper
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
    @collab_project = @branch.collabproject
    @branch.leaves.empty? ? @all_leaves = nil : @all_leaves = @branch.leaves.limit(25).includes(:leafable, :branch, { comments: [ { collaborator: [:admin] } ] } )
    @active_leaf = @all_leaves.first
    @branch.child_branches ? @child_branches = @branch.child_branches : @child_branches = nil
    @leaf = Branch.find(params[:id]).leaves.new
    @video_upload = VideoUpload.new
    @source_youtube = SourceYoutube.new
    @source_text = SourceText.new
    @new_comment = Comment.new
    @branch_comments = @branch.comments.limit(25).includes(collaborator: [:admin]).hash_tree
    @is_current_admin_collaborator = current_admin_collaborator?(@collab_project.id)
  end

  def destroy
    branch = Branch.find(params[:id])
    if current_admin == branch.creator.admin or current_admin == branch.collabproject.creator.admin
      branch.destroy
      flash[:success] = "Branch deleted"
    end
    redirect_to collab_project_path(branch.collabproject)
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

end
