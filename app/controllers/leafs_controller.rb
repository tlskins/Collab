class LeafsController < ApplicationController
  def new
    @leaf = Leaf.new
  end

  def create
    @leaf = Branch.find(params[:branch_id]).leaves.new(leaf_params)
    if @leaf.save
      flash[:success] = 'Leaf created!'
      redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
    else
      render :new
    end
  end

  def show
    @leaf = Leaf.find(params[:id])
  end

  private

  def leaf_params
    params.require(:leaf).permit(:link)
  end
end
