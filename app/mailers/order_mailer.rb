class OrderMailer < Base
  default bcc: ADMIN_EMAIL if Rails.env.production?
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.paid.subject
  #
  def paid(order)
    @order        = order
    @certificates = order.certificates
    @charities    = order.charities
    @deals        = @order.deals
    @merchants    = @deals.map(&:merchant_names).flatten.uniq
    charities_names = @charities.map(&:name).to_sentence
    mail to: order.buyer.email, from: SENDER_EMAIL, 
      subject: "Your Givegoods.org #{"donation".pluralize(@charities.size)} to #{charities_names}"
  end
end
