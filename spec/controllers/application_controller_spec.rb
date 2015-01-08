require 'spec_helper'

describe ApplicationController do

  describe "#after_sign_in_path_for" do
    describe "for a AdminUser" do
      let(:user) { mock_model(AdminUser) }

      it "redirects to admin dashboard" do
        subject.after_sign_in_path_for(user).should eq(admin_dashboard_path)
      end
    end

    describe "for a User" do 
      let(:user) { mock_model(User) }

      describe "when user has no role" do
        it "redirects to user role selection" do
          subject.after_sign_in_path_for(user).should eq(new_user_role_assignment_path)
        end
      end

      describe "when user has charity role" do
        before do
          user.stub(:role).and_return('charity')
        end

        it "redirects to new charity" do
          subject.after_sign_in_path_for(user).should eq(new_user_charity_path)
        end
      end

      describe "when user has merchant role" do
        before do 
          user.stub(:role).and_return('merchant')
        end

        it "redirects to new merchant" do
          subject.after_sign_in_path_for(user).should eq(new_user_merchant_path)
        end
      end
    end
  end

end
