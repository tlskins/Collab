module PublicActivityHelper

  def load_activities_hash(activities)
    puts 'begin load_activites_hash'
    @activities_array = []
    activities.each do |a|
      current_activity = {}
      action = a.key.match(/\.(.*)/)[1]

      #Add CSS Class
      if a.created_at > (Time.now - 5.minutes)
        current_activity.store("css class", "list-group-item-warning")
      elsif a.created_at  > (Time.now - 1.day)
        current_activity.store("css class", "list-group-item-info")
      else
        current_activity.store("css class", "")
      end

      #Add glyphicon
      current_activity.store("glyphicon", action)

      #Add event owner name
      current_activity.store("owner", a.owner ? a.owner.name : 'Guest')

      #Add created_at
      current_activity.store("created_at", a.created_at)

      #Add text
      if a.trackable_type == 'Branch' or a.trackable_type == 'CollabProject'
        current_activity.store( "text", a.key ? action + ' the ' + a.trackable_type : 'Notification not found!')
      else
        current_activity.store( "text", a.key ? action + ' a ' + a.trackable_type + ' on the Branch' : 'Notification not found!')
      end

      #Add name
      current_activity.store("name", a.name ? a.name : " not found")

      #Add link
      if (a.trackable and a.trackable_type == 'Branch' and a.trackable.collabproject)
        current_activity.store( "link", collab_project_branch_path(:collab_project_id => a.trackable.collabproject.id, :id => a.trackable.id) )

      elsif (a.trackable and a.trackable_type.start_with?('Source') and a.trackable.leaf)
        current_activity.store( "link", collab_project_branch_path(:collab_project_id => a.trackable.leaf.branch.collabproject.id, :id => a.trackable.leaf.branch.id) )

      elsif (a.trackable and a.trackable_type == 'Comment' and a.trackable.commentable)
	if a.trackable.commentable.class.to_s == 'Branch'
          current_activity.store( "link", collab_project_branch_path(:collab_project_id => a.trackable.commentable.collabproject.id, :id => a.trackable.commentable.id) )
        elsif a.trackable.commentable.class.to_s == 'Leaf'
          current_activity.store( "link", collab_project_branch_path(:collab_project_id => a.trackable.commentable.branch.collabproject.id, :id => a.trackable.commentable.branch.id) )
        elsif a.trackable.commentable.class.to_s == 'CollabProject'
          current_activity.store( "link", collab_project_path(a.trackable.commentable) )
        end

      elsif (a.trackable and a.trackable_type == 'CollabProject')
        current_activity.store( "link", collab_project_path(:id => a.trackable.id) )

      else
        current_activity.store( "link", nil )
      end

      #Add collab name
      current_activity.store( "collab_name", a.collab_name )

      @activities_array << current_activity
    end
    return @activities_array
  end

end
