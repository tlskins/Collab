class NotificationMailer < ActionMailer::Base
  default from: "collab.mailer@collab.com"

  def notification(admin_id, collabproject, admin_sender, link, message)
    @collabproject = collabproject
    @admin_sender = admin_sender
    @message = message
    @link = link
    @admin = Admin.find(admin_id)
    email_with_name = %("#{@admin.name}" <#{@admin.email}>)
    mail(to: email_with_name, subject: "Collab notification from #{@admin_sender.name} for #{@collabproject.name}")
  end

end
