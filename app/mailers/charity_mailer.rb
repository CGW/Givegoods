class CharityMailer < Base
  def activated_charity(charity)
    @charity = charity
    greeting(charity.user.first_name)
    mail to: charity.user.email
  end
end

