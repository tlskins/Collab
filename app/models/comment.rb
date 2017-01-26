class Comment < ActiveRecord::Base
  belongs_to :commentary, polymorphic: true
  belongs_to :author, class_name: "Collaborator", foreign_key: :author_id
end
