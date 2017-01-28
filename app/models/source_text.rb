class SourceText < ActiveRecord::Base
  belongs_to :leaf
  #validates :title, presence: true, length: {maximum: 140}
  validates :text, presence: true
end
