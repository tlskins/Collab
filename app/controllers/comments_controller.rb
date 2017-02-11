class CommentsController < ApplicationController

#  def index
#    @comments = Comment.hash_tree
#  end

  def new
    if params[:parent_id]
      @comment = Comment.new(parent_id: params[:parent_id])
    end
  end

  def create
    @comment = Comment.new(comment_params)

    # Branch comment
    if params[:branch_id]
      branch = Branch.find(params[:branch_id])
      @comment.commentable = branch
      @comment.collaborator = Collaborator.find_by(collab_id: branch.collabproject.id, admin_id: current_admin.id)
      if @comment.save
        flash[:success] = 'Your comment was successfully added!'
      else
        flash[:warning] = 'Your comment failed!'
      end
      redirect_to collab_project_branch_path(branch.collabproject, branch)

    # Leaf comment
    elsif params[:leaf_id]
      leaf = Leaf.find(params[:leaf_id])
      @comment.commentable = leaf
      @comment.collaborator = Collaborator.find_by(collab_id: leaf.branch.collabproject.id, admin_id: current_admin.id)
      if @comment.save
        flash[:success] = 'Your comment was successfully added!'
      else
        flash[:warning] = 'Your comment failed!'
      end
      redirect_to collab_project_branch_path(leaf.branch.collabproject, leaf.branch)

    # Collab comment
    elsif params[:collabproject_id]
      collab = CollabProject.find(params[:collabproject_id])
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
    branch = comment.branch
    if current_admin.id  == comment.collaborator.admin.id
      comment.destroy
      flash[:success] = "Game deleted"
    end
    redirect_to collab_project_branch_path(branch.collabproject, branch)
  end

private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

end
