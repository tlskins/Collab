class CommentsController < ApplicationController
  include CollaboratorHelper
  before_action :check_is_collaborator_by_id, only: [:destroy]

  def new
    @current_page = params[:page]
    @active_leaf = Leaf.find_by(id: params[:active_leaf])
    if params[:parent_id]
      @comment = Comment.new(parent_id: params[:parent_id])
    end
  end

  def create
    @comment = Comment.new(comment_params)

    # Branch comment
    if params[:branch_id]
      branch = Branch.find(params[:branch_id])
      # Access verification
      (redirect_to root_path?) if (!current_admin_collaborator?(branch.collabproject.id))
      @comment.commentable = branch
      @comment.collaborator = Collaborator.find_by(collab_id: branch.collabproject.id, admin_id: current_admin.id)
      if @comment.save
        flash[:success] = 'Your comment was successfully added!'
      else
        flash[:warning] = 'Your comment failed!'
      end
    redirect_to collab_project_branch_path(branch.collabproject, branch, :page => params[:page], :active_leaf => params[:active_leaf])

    # Leaf comment
    elsif params[:leaf_id]
      leaf = Leaf.find(params[:leaf_id])
      # Access verification
      (redirect_to root_path?) if (!current_admin_collaborator?(leaf.branch.collabproject.id))
      @comment.commentable = leaf
      @comment.collaborator = Collaborator.find_by(collab_id: leaf.branch.collabproject.id, admin_id: current_admin.id)
      if @comment.save
        flash[:success] = 'Your comment was successfully added!'
      else
        flash[:warning] = 'Your comment failed!'
      end
    redirect_to collab_project_branch_path(leaf.branch.collabproject, leaf.branch, :page => params[:page], :active_leaf => params[:active_leaf])

    # Collab comment
    elsif params[:collabproject_id]
      collab = CollabProject.find(params[:collabproject_id])
      # Access verification
      (redirect_to root_path?) if (!current_admin_collaborator?(collab.id))
      @comment.commentable = collab
      @comment.collaborator = Collaborator.find_by(collab_id: collab.id, admin_id: current_admin.id)
      if @comment.save
        flash[:success] = 'Your comment was successfully added!'
      else
        flash[:warning] = 'Your comment failed!'
      end
      redirect_to collab_project_path(collab)

    end

  end

  def destroy
    comment = Comment.find(params[:id])
    if current_admin.id  == comment.collaborator.admin.id
      comment.destroy
      flash[:success] = "Comment deleted"
    end

    if comment.commentable_type == 'CollabProject'
      redirect_to collab_project_path(comment.commentable)
    elsif comment.commentable_type == 'Branch'
      redirect_to collab_project_branch_path(comment.commentable.collabproject, comment.commentable, :page => params[:page], :active_leaf => params[:active_leaf])
    elsif comment.commentable_type == 'Leaf'
      redirect_to collab_project_branch_path(comment.commentable.branch.collabproject, comment.commentable.branch, :page => params[:page], :active_leaf => comment.commentable.id)
    else
      redirect_to root_path
    end
  end

private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def check_is_collaborator_by_id
    comment = Comment.find(params[:id])

    if comment.commentable_type == 'CollabProject'
      if !(current_admin_collaborator?(comment.commentable.id))
        redirect_to root_path
      end
    elsif comment.commentable_type == 'Branch'
      if !(current_admin_collaborator?(comment.commentable.collabproject.id))
        redirect_to root_path
      end
    elsif comment.commentable_type == 'Leaf'
      if !(current_admin_collaborator?(comment.commentable.branch.collabproject.id))
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

end
