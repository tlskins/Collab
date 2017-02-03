class Collaborator < ActiveRecord::Base
  belongs_to :admin
  belongs_to :collabproject, class_name: "CollabProject", foreign_key: :collab_id 
  has_one :child_collabproject, class_name: "CollabProject", foreign_key: :creator_id
  has_many :comments

  def self.ids
    pluck(:id)
  end

  def name
    if admin
      return admin.name
    end
  end
  
end
