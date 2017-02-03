class SourceYoutube < ActiveRecord::Base
  belongs_to :leaf
  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
  validates :link, presence: true, format: YT_LINK_FORMAT

  def update_link(update_link)
    update_attributes(link: update_link)
  end

end
