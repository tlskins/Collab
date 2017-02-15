class SourceYoutubesController < ApplicationController

  def create
    leaf = Branch.find(params[:branch_id]).leaves.create(title: params[:youtube_title])
    leafable_youtube = SourceYoutube.new(source_youtube_params)
    leafable_youtube.leaf = leaf

    if leafable_youtube.save
      flash[:success] = 'Leaf Created!'
    else
      flash[:alert] = 'Leaf Creation Failed!'
    end
    redirect_to collab_project_branch_path(leaf.branch.collabproject, leaf.branch, :active_leaf => leaf.id)
  end

  def edit_yt
    source_youtube = SourceYoutube.find(params[:id])
    source_youtube.update_link(params[:source_youtube][:link])
    source_youtube.update_text(params[:content_yt])
    source_youtube.leaf.update_title(params[:youtube_title])
    redirect_to collab_project_branch_path(source_youtube.leaf.branch.collabproject, source_youtube.leaf.branch, :page => params[:page], :active_leaf => source_youtube.leaf.id)
  end

  private

  def source_youtube_params
    params.require(:source_youtube).permit(:link, :text)
  end

end
