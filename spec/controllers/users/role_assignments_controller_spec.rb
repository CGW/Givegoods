require 'spec_helper'

describe Users::RoleAssignmentsController do
  let(:user) { create(:user) }

  describe "for anonymous users" do
    it "GET :new redirects" do
      get :new
      response.should redirect_to(user_session_path)
    end

    it "POST :create redirects" do
      post :create
      response.should redirect_to(user_session_path)
    end
  end

  describe "for users with a role" do
    before do
      user.role = 'charity'
      user.save!

      sign_in(user)
    end

    it "GET :new redirects" do
      get :new
      response.should redirect_to(controller.after_sign_in_path_for(user))
    end

    it "POST :create redirects" do
      post :create
      response.should redirect_to(controller.after_sign_in_path_for(user))
    end
  end

  describe "GET :new" do
    before do
      # Delete "Sign-in" default notice from Devise.
      flash = mock('Flash')
      subject.should_receive(:flash).and_return(flash)
      flash.should_receive(:delete).with(:notice)

      sign_in(user)
      get :new
    end

    it { should respond_with(:success) }
    it { should render_template('layouts/bootstrap/application') }
    it { should render_template('users/role_assignments/new') }
  end

  describe "POST :create" do
    let(:role_assignment) { mock(RoleAssignment) }

    before do
      role_assignment.should_receive(:user=).with(user)
      sign_in(user)
    end

    describe "successfully" do
      before do
        RoleAssignment.should_receive(:new).with({'role' => 'superman'}).and_return(role_assignment)
        role_assignment.should_receive(:save).and_return(true)

        post :create, :role_assignment => {:role => 'superman'}
      end

      it { should redirect_to(subject.after_sign_in_path_for(user)) }
    end

    describe "with errors" do
      before do
        RoleAssignment.should_receive(:new).with({}).and_return(role_assignment)
        role_assignment.should_receive(:save).and_return(false)

        post :create, :role_assignment => {}
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/application') }
      it { should render_template('users/role_assignments/new') }
    end
  end
end
