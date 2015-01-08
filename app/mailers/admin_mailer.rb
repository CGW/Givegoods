class AdminMailer < Base
  default to: ADMIN_EMAIL

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_merchant.subject
  #
  def new_merchant(merchant)
    @merchant = merchant
    greeting("Admin")
    mail from: SENDER_EMAIL
  end

  def update_merchant(merchant)
    @merchant = merchant
    greeting("Admin")
    mail
  end

  def new_charity(charity)
    @charity = charity
    greeting("Admin")
    mail from: SENDER_EMAIL
  end

  def activated_charity(charity)
    @charity = charity
    greeting("Admin")
    mail from: SENDER_EMAIL
  end
end
