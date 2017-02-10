class VideoUploadsController < ApplicationController

  def create
    @video_upload = VideoUpload.new(title: params[:video_upload][:title],
                                  description: params[:video_upload][:description],
                                  file: params[:video_upload][:file].try(:tempfile).try(:to_path))
    branch = Branch.find(params[:branch_id])
    if @video_upload.save
      uploaded_video = @video_upload.upload!(current_user)

      if uploaded_video.failed?
        flash[:error] = 'There was an error while uploading your video...'
      else
        video = Video.create({link: "https://www.youtube.com/watch?v=#{uploaded_video.id}"})
        leaf_yt = branch.leaves.create(title: params[:video_upload][:title])
        @leafable_yt = SourceYoutube.new(link: video.link, text: params[:video_upload][:description], leaf: leaf_yt)
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

end
