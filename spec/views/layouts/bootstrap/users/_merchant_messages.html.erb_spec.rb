require 'spec_helper'

describe 'layouts/bootstrap/users/_merchant_messages' do
  let(:user) { mock_model(User, :merchant => nil) }
  let(:merchant)  { mock_model(Merchant) }

  before do
    view.stub(:current_user).and_return(user)
  end

  it "does not have a notice" do
    render
    rendered.should_not have_selector('div.alert')
  end

  describe "when user has a merchant and that is not active" do
    before do
      user.stub(:merchant).and_return(merchant)
      merchant.stub(:active?).and_return(false)
      render
    end

    it "has inactive notice" do
      rendered.should have_selector('div.alert')
    end
  end
end
