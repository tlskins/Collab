class Leaf < ActiveRecord::Base
  belongs_to :branch
  has_one :source_youtube
  has_one :source_text

end
