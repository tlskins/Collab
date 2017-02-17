class InviteMailer < ActionMailer::Base
  default from: "collab.mailer@collab.com"

  def invite(invite)
    @invite = invite
    email_with_name = %("#{invite.name}" <#{invite.email}>)
    mail(to: email_with_name, subject: "You've been invited to collaborate on #{invite.collabproject.name}!")
  end

end
