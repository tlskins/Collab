class LeafsController < ApplicationController
  def new
    @leaf = Branch.find(params[:branch_id]).leaves.new
  end

  def create
    @leaf = Branch.find(params[:branch_id]).leaves.new(leaf_params)
    if @leaf.save
      if params[:text]
        @leaf.create_source_text(text: params[:text])
      end
      if params[:link]
        @leaf.create_source_youtube(link: params[:link])
      end
      flash[:success] = 'Leaf created!'
      redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
    else
      render :new
    end
  end

  def show
    @leaf = Leaf.find(params[:id])
    @source = @leaf.source
  end

  private 

  def leaf_params
    params.require(:leaf).permit(:name, :branch_id, :order)
  end

end
