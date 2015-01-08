require 'spec_helper'

describe 'users/charities/edit' do
  let(:charity)     { create(:charity) }
  let(:user_policy) { ActiveCharityPolicy.new(charity) }

  before do
    view.stub(:user_policy).and_return(user_policy)
    user_policy.stub(:active?).and_return(true)
    assign(:charity, charity)
  end

  it "has title" do
    render
    rendered.should have_selector('h1', :text => 'Edit charity profile')
  end

  describe "when user_policy is inactive" do
    before do
      user_policy.stub(:active?).and_return(false)
      render
    end

    it "has a title" do
      rendered.should have_selector('h1', :text => 'Almost Finished')
    end

    it "has instructions" do
      rendered.should have_content('You must complete a few pieces of information below before your charity page can go live.')
    end
  end

  it "renders the charity form" do
    render
    view.should render_template(:partial => 'users/charities/_form')
  end
end
