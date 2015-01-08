require 'spec_helper'

describe 'layouts/bootstrap/users/_charity_messages' do
  let(:user)        { mock_model(User, :charity => nil) }
  let(:charity)     { mock_model(Merchant) }
  let(:user_policy) { mock('Policy', :active? => false) }

  before do
    view.stub(:user_policy).and_return(user_policy)
    view.stub(:current_user).and_return(user)
  end

  it "does not have a notice" do
    render
    rendered.should_not have_selector('div.alert')
  end

  describe "when user has a charity and that is not active" do
    before do
      user.stub(:charity).and_return(charity)
      user_policy.stub(:active?).and_return(true)
      charity.stub(:active?).and_return(false)
      render
    end

    it "has inactive notice" do
      rendered.should have_selector('div.alert')
    end
  end
end
