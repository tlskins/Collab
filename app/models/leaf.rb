class Leaf < ActiveRecord::Base
  belongs_to :branch
  has_one :source_youtube
  has_one :source_text

  def update_link(update_link)
    if source_youtube
      source_youtube.update_link(update_link)
    else
      self.create_source_youtube(link: update_link)
    end
  end

  def update_text(update_text)
    if source_text
      source_text.update_text(update_text)
    else
      self.create_source_text(text: update_text)
    end
  end

end
