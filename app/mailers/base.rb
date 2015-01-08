# Base mailer for defaults
class Base < ActionMailer::Base
  ADMIN_EMAIL  = "admin@givegoods.org"
  SENDER_EMAIL = "info@givegoods.org"
  default from: SENDER_EMAIL
  
  def greeting(name = nil)
    @greeting = name ? "Hello %s" % name : "Hello"
  end
end
