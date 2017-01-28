class BranchesController < ApplicationController
  def new
    @branch = Branch.new
    if params[:branch_id]
      @parent_branch = Branch.find_by(id: params[:branch_id])
    end 
  end

  def create
    collab_project = CollabProject.find(params[:collab_project_id])
    parent_branch = Branch.find_by(id: params[:branch_id])
    @branch = collab_project.branches.new(branch_params)
    if @branch.save
      @branch.add_creator(current_admin)
      if parent_branch
        puts 'Parent Branch Exists!'
        @branch.add_parent_branch(parent_branch)
      end
      flash[:notice] = "Successfully created Branch!"
      redirect_to collab_project_branch_path(@branch.collabproject, @branch)
    else
      flash[:alert] = "Error creating new Branch!"
      render :new
    end
  end

  def show
    @branch = Branch.find(params[:id])
    @collab_project = @branch.collabproject
    @branch.leaves ? @leaf = @branch.leaves.last : @leaf = nil
    @branch.child_branches ? @child_branches = @branch.child_branches : @child_branches = nil
    @leaf = Branch.find(params[:id]).leaves.new
    @source_text = @leaf.build_source_text
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

end
