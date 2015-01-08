class FreeOfferMailer < Base
  default bcc: ADMIN_EMAIL if Rails.env.production? 

  def certificate(certificate) 
    @certificate = certificate
    mail to: certificate.customer.email,
      subject: "Your Free Alameda Reward From Givegoods"
  end
end
