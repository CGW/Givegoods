class EmailService
  class << self
    def new_charity(charity)
      AdminMailer.new_charity(charity).deliver
    end

    def activated_charity(charity)
      AdminMailer.activated_charity(charity).deliver
      CharityMailer.activated_charity(charity).deliver
    end
  end
end
