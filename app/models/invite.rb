class Invite < ActiveRecord::Base
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validate :not_registered

  before_create :new_invite_token
  belongs_to :collabproject, class_name: "CollabProject", foreign_key: :collab_id

  def new_invite_token
    self.invite_token = SecureRandom.urlsafe_base64.to_s
  end

  private

  def not_registered
    puts 'not_registered invite validation called'
    admin = Admin.find_by(email: self.email.downcase)
    if admin
      puts 'not_registered - admin exists'
      if collabproject.collaborators.admin_ids.include?(admin.id)
        errors.add(:category, "User " + admin.name + " is already a collaborator on this project!")
      end
      errors.add(:category, "User already registered under name " + admin.name + ", to give them collaborator access please use the Add Collaborator form below.")
    end
  end

end
