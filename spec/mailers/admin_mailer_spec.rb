require 'spec_helper'

describe AdminMailer do
  describe '#new_charity' do
    let(:charity) { create(:charity) }
    let(:mail)    { AdminMailer.new_charity(charity) }

    it "has a subject" do
      mail.subject.should eq('A new charity has been created')
    end

    it "has a recipient" do
      mail.to.should eq([Base::ADMIN_EMAIL])
    end

    it "has contents" do
      content = mail.body.to_s

      content.should include(charity.name)
      content.should include(admin_charity_url(charity))
    end
  end

  describe '#activated_charity' do
    let(:charity) { create(:charity) }
    let(:mail)    { AdminMailer.activated_charity(charity) }

    it "has a subject" do
      mail.subject.should eq('A charity has been activated')
    end

    it "has a recipient" do
      mail.to.should eq([Base::ADMIN_EMAIL])
    end

    it "has contents" do
      content = mail.body.to_s

      content.should include(charity.name)
      content.should include(admin_charity_url(charity))
      content.should include(charity_landing_url(charity))
    end
  end
end
