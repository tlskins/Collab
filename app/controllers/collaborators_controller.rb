class CollaboratorsController < ApplicationController

  def new
    @collab_project = CollabProject.find(params[:collab_project_id])
    @invite = Invite.new(collabproject: @collab_project)
    if current_admin
      @avail_collaborators = Admin.where("id not in (:x)", :x => CollabProject.find_by(id: params[:collab_project_id]).collaborators.admin_ids)
      @collaborator = @collab_project.collaborators.build
    else
      flash[:warning] = "Must be logged in!"
      redirect_to root_path
    end
  end

  def create
    @collab_project = CollabProject.find(params[:collab_project_id])
    @collaborator = @collab_project.collaborators.new(collaborator_params)
    if @collaborator.save
      flash[:success] = 'Collaborator Added!'
    end

    redirect_to collab_project_path(@collab_project)
  end

  def invite
    puts 'begin collaborators#invite'
    @collab_project = CollabProject.find(params[:collab_project_id])
    @invite = Invite.find_by(email: params[:invite][:email], collab_id: params[:collab_project_id])

    # Either generate new invite token or create a new invite
    if @invite
      puts 'existing invite found, creating new token'
      @invite.new_invite_token
      @invite.reload
    else
      puts 'create new invite'
      @invite = Invite.new(invite_params)
      @invite.collabproject = @collab_project
      if @invite.save
        @invite.reload
      else
        @avail_collaborators = Admin.where("id not in (:x)", :x => CollabProject.find_by(id: params[:collab_project_id]).collaborators.admin_ids)
        @collaborator = @collab_project.collaborators.build
	flash[:warning] = 'Invite failed!'
	render 'new'
	return
      end
    end
    InviteMailer.invite(@invite).deliver_later
    redirect_to collab_project_path(@collab_project)
  end 


  private

  def collaborator_params
    params.require(:collaborator).permit(:admin_id, :collab_id)
  end

  def invite_params
    params.require(:invite).permit(:collab_id, :name, :email)
  end

end
