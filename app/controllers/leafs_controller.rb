class LeafsController < ApplicationController
  def new
    @leaf = Branch.find(params[:branch_id]).leaves.new
  end

  def create
    @leaf = Branch.find(params[:branch_id]).leaves.new

    if @leaf.save
      if params[:text]
        @leaf.create_source_text(text: params[:text])
      end
      if params[:link]
        @leaf.create_source_youtube(link: params[:link])
      end
      flash[:success] = 'Leaf Created!'
    end
    redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
  end

  def edit
    @leaf = Leaf.find(params[:leaf_id])
    @leaf.update_text(params[:text])
    @leaf.update_link(params[:link])
    flash[:success] = 'Leaf Updated!'

    redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
  end

  def show
    @leaf = Leaf.find(params[:id])
    @source = @leaf.source
  end

end
