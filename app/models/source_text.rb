class SourceText < ActiveRecord::Base
  belongs_to :leaf
  #validates :title, presence: true, length: {maximum: 140}
  validates :text, presence: true

  def update_text(update_text)
    update_attributes(text: update_text)
  end

end
