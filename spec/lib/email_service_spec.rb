require 'spec_helper'

describe EmailService do
  let(:mail) { double('MailObject') }
  let(:charity) { double('Charity') }

  describe ".new_charity" do
    before do
      mail.should_receive(:deliver).once
      AdminMailer.should_receive(:new_charity).with(charity).and_return(mail)
    end

    it "sends email to admin" do
      EmailService.new_charity(charity)
    end
  end

  describe ".activated_charity" do
    before do
      mail.should_receive(:deliver).twice
      AdminMailer.should_receive(:activated_charity).with(charity).and_return(mail)
      CharityMailer.should_receive(:activated_charity).with(charity).and_return(mail)
    end

    it "sends email admin and charity user" do
      EmailService.activated_charity(charity)
    end
  end
end
