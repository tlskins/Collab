class LeafsController < ApplicationController
  include CollaboratorHelper

  def new
    @leaf = Branch.find(params[:branch_id]).leaves.new
  end

  def create
    branch = Branch.find(params[:branch_id])
    if params[:branch_id]
  
      unless params[:text].empty?
        leaf_text = Branch.find(params[:branch_id]).leaves.create(title: params[:text_title])
        @leafable_text = SourceText.new(text: params[:text], leaf: leaf_text)
        if @leafable_text.save
	  flash[:success] = 'Leaf Created!'
        else
	  flash[:alert] = 'Leaf Creation Failed!'
        end
      end

      unless params[:link].empty?
        leaf_yt = Branch.find(params[:branch_id]).leaves.create(title: params[:youtube_title])
        @leafable_yt = SourceYoutube.new(link: params[:link], leaf: leaf_yt)
        if @leafable_yt.save
          flash[:success] = 'Leaf Created!'
        else
          flash[:alert] = 'Leaf Creation Failed!'
        end
      end
    else
      flash[:alert] = 'Leaf Creation Failed!'
    end
    redirect_to collab_project_branch_path(branch.collabproject, branch)
  end

  def edit
    @leaf = Leaf.find(params[:id])

    if @leaf.leafable.class.to_s == 'SourceText'
      @leaf.update_title(params[:text_title])
      @leaf.update_text(params[:text])
      flash[:success] = 'Leaf Updated!'
    elsif @leaf.leafable.class.to_s == 'SourceYoutube' and params[:link]
      @leaf.update_title(params[:youtube_title])
      @leaf.update_link(params[:link])
      flash[:success] = 'Leaf Updated!'
    else
      flash[:alert] = 'Leaf Updated failed!'
    end

    redirect_to collab_project_branch_path(@leaf.branch.collabproject, @leaf.branch)
  end

  def show
    @leaf = Leaf.find(params[:id])
    @source = @leaf.source
  end

  def destroy
    leaf = Leaf.find(params[:id])
    if current_admin_collaborator?(leaf.branch.collabproject.id)
      leaf.leafable.destroy
      leaf.save
      leaf.reload
      leaf.destroy
      flash[:success] = "Leaf deleted"
    end
    redirect_to collab_project_branch_path(leaf.branch.collabproject, leaf.branch)
  end

  private 


  def find_leafables
    if params[:text]
      @leafable_text = SourceText.new(text: params[:text])
    end
    if params[:link]
      @leafable_yt = SourceYoutube.new(link: params[:link])
    end

    #params.each do |name, value|
    #  if name =~ /(.+)_id$/
    #    return $1.classify.constantize.find(value)
    #  end
    #end
    #nil
  end

end
