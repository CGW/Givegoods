
shared_context "devise view" do
  let(:resource) { stub_model(User) }

  before do
    # Not happy about having to stub this out completely, need a better solution.
    view.stub(:resource).and_return(resource)
    view.stub(:resource_name).and_return(:user)
    view.stub(:devise_mapping).and_return(mock('DeviseMapping', :rememberable? => true))
  end
end
