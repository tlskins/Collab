class SourceTextsController < ApplicationController

  def create
    leaf = Branch.find(params[:branch_id]).leaves.create(title: params[:text_title])
    leafable_text = SourceText.new(text: params[:source_text][:text], leaf: leaf)

    if leafable_text.save
      flash[:success] = 'Leaf Created!'
    else
      flash[:alert] = 'Leaf Creation Failed!'
    end
    redirect_to collab_project_branch_path(leaf.branch.collabproject, leaf.branch)
  end

end
