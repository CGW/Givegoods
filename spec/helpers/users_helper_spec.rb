
require 'spec_helper'

describe UsersHelper do
  describe "#user_policy" do
    let(:current_user) { double('User') }
    let(:policy)       { double('Policy') }
    let(:charity)      { double('Charity') }
    
    before do
      helper.stub(:current_user).and_return(current_user)
    end

    it "returns nil when user has no role" do
      current_user.should_receive(:role).and_return(nil)
      helper.user_policy.should be_nil
    end

    it "returns new ActiveCharityPolicy when user has charity role" do
      current_user.should_receive(:role).and_return('charity')
      current_user.should_receive(:charity).and_return(charity)
      ActiveCharityPolicy.should_receive(:new).with(charity).and_return(policy)

      helper.user_policy.should eq(policy)
    end
  end

  describe "#policy_alert" do
    let(:policy) { double('Policy') }
    let(:attr)   { 'basic_information' }
    let(:message) { 'You need to fill out the basics nerd.' }

    before do
      policy.stub(:active?).and_return(true)
      policy.stub(:message_for).with(attr).and_return(message)
      policy.stub(:errors).and_return(Hash.new)
    end

    it "returns an empty string when policy is active" do
      helper.policy_alert(policy, attr).should eq('')
    end

    describe "when the policy is inactive" do
      before do
        policy.stub(:active?).and_return(false)
      end

      it "returns an alert box with the message" do
        result = helper.policy_alert(policy, attr)
        result.should have_selector('div.alert .alert-policy-status', :text => "COMPLETE")
        result.should have_selector('div.alert.alert-block.alert-policy', :text => /\d+\. #{message}/)
      end

      describe "when the policy task has errors" do
        before do
          policy.stub(:errors).and_return({attr => [message]})
        end

        it "returns an incomplete alert box" do
          result = helper.policy_alert(policy, attr)
          result.should have_selector('div.alert .alert-policy-status', :text => "INCOMPLETE")
          result.should have_selector('div.alert.alert-error')
        end
      end
    end
  end
end
