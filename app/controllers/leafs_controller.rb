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
      flash[:success] = 'Leaf Created!'
    end
    redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
  end

  def edit
    @leaf = Leaf.find(params[:leaf_id])

    if params[:text]
      if @leaf.source_text
        @leaf.source_text.text = params[:text]
        @leaf.save
      else
        @leaf.create_source_text(text: params[:text])
      end
      flash[:success] = 'Leaf Updated!'
    end

    if params[:link]
      if @leaf.source_youtube
        @leaf.source_youtube.link = params[:link]
        @leaf.save
      else
        @leaf.create_source_youtube(link: params[:link])
      end
      flash[:success] = 'Leaf Updated!'
    end

    redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
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
