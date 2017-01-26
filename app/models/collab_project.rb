class CollabProject < ActiveRecord::Base
  has_many :branches, class_name: "Branch", foreign_key: :collab_id, dependent: :destroy
  has_many :attached_branches, -> { where attached: true }, class_name: "Branch", foreign_key: :collab_id
  has_many :unattached_branches, -> { where attached: false }, class_name: "Branch", foreign_key: :collab_id
  has_many :collaborators, class_name: "Collaborator", foreign_key: :collab_id, dependent: :destroy
  has_many :comments, as: :commentary, dependent: :destroy
  belongs_to :creator, class_name: "Collaborator", foreign_key: :creator_id

  def CollabProject.find_by_admin(admin)
    collabs = []
    Collaborator.where(admin_id: admin.id).each do |c|
      if c.collabproject
        collabs << c.collabproject
      end
    end
    return collabs
  end

  def add_creator(admin)
    collaborator = Collaborator.find_by(admin_id: admin.id, collab_id: self.id)
    unless collaborator
      collaborator = Collaborator.create!(admin: admin, collabproject:self)
    end
    update_attributes(creator_id: collaborator.id)
  end

  def add_collaborator(admin)
    collaborator = Collaborator.find_by(admin_id: admin.id, collab_id: self.id)
    unless collaborator
      Collaborator.create!(admin: admin, collabproject: self)
    end
  end

  def list_collaborators
    if collaborators
      collaborators.map { |c| c.name.to_s + " | " }.join.to(-4)
    end
  end

  def branch_images
    images = []
    branches.each do |b|
      if b.leaves.last
        images << "https://img.youtube.com/vi/#{b.leaves.last.uid}/mqdefault.jpg"
      end
    end
    return images
  end

end
