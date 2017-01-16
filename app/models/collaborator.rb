class Collaborator < ActiveRecord::Base
  belongs_to :admin
  belongs_to :collab
  
end
