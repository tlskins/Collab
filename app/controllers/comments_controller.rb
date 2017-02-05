class CommentsController < ApplicationController

  def index
    @comments = Comment.hash_tree
  end

  def new
    @branch = Branch.find(params[:branch_id])
    @comment = Comment.new(parent_id: params[:parent_id])
  end

  def create
    branch = Branch.find(params[:branch_id])
    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by(id: params[:comment][:parent_id])
      @comment = parent.children.build(parent_id: params[:comment][:parent_id], body: params[:comment][:body], branch_id: params[:branch_id], collaborator_id: Collaborator.find_by(collab_id: branch.collabproject.id, admin_id: current_admin.id).id)
    else
      @comment = branch.comments.new(body: params[:comment][:body], collaborator_id: Collaborator.find_by(collab_id: branch.collabproject.id, admin_id: current_admin.id).id)
    end

    if @comment.save
      #@comment.add_creator_by_admin(current_admin.id, branch.collabproject.id)
      flash[:success] = 'Your comment was successfully added!'
    end
    redirect_to collab_project_branch_path(branch.collabproject, branch)
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
    params.require(:comment).permit(:body, :branch_id)
  end

end
