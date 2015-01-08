require 'spec_helper'

describe CharityMailer do
  describe '#activated_charity' do
    let(:charity) { create(:charity, :user => create(:user)) }
    let(:mail)    { CharityMailer.activated_charity(charity) }

    it "has a subject" do
      mail.subject.should eq("Givegoods: Your charity has been activated")
    end

    it "has a recipient" do
      mail.to.should eq([charity.user.email])
    end

    it "has contents" do
      content = mail.body.to_s

      content.should include(charity.name)
      content.should include(charity_landing_url(charity))
    end
  end
end
