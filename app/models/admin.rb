class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #mount avatar uploader
  mount_uploader :avatar, AvatarUploader
  has_many :collaborators, class_name: "Collaborator"

end
