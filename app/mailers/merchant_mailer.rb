class MerchantMailer < Base
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.merchant_mailer.pending.subject
  #
  def pending(merchant)
    @merchant = merchant
    greeting(merchant.name)
    mail to: merchant.email, from: SENDER_EMAIL
  end
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.merchant_mailer.active.subject
  #
  def active(merchant)
    @merchant = merchant
    greeting(merchant.name)
    mail to: merchant.email, from: SENDER_EMAIL
  end
end
