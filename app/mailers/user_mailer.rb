class UserMailer < ActionMailer::Base
  default_url_options[:host] = "interestinglinks.heroku.com"
  def userconfirmation(user)
    setup_email(user,"Registration")
  end
  def urlnotiication(link,user)
    setup_email(user,"A new link added")
    @newlink = link.link
  end
  def linknotification(link,user,current_user)
    setup_email(user,"A new link added")
    @newlink =  link.link
    @addedby = current_user.username
  end
  def forgot_password(user,resetcode)
    setup_email(user, "reset your password")
    @resetcode = resetcode
  end
  def invitation(user,resetcode,groupname)
    setup_email(user, "Invitation from BlendMark")
    @resetcode = resetcode
    @password = user.password
    @groupname = groupname
  end
  protected
  def setup_email(user,subject)
    @recipients = "#{user.email}"
    @from = ENV["mail_username"]
    @sent_on = Time.now
    @body[:user] = user
    @subject = subject
    @name = user.username
  end
end
