require 'spec_helper'

describe Users::CertificatesController do
  let(:user)    { create(:user) }

  describe "for anonymous users" do
    it "GET :show redirects" do
      get :show
      subject.should redirect_to(user_session_path)
    end

    it "PUT :update redirects" do
      put :update
      subject.should redirect_to(user_session_path)
    end
  end

  describe "for a user without a merchant" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:merchant).and_return(nil)

      sign_in(user)
    end

    describe "users are redirected to new merchant path" do
      it "GET :show" do
        get :show
        subject.should redirect_to(new_user_merchant_path)
      end

      it "PUT :update" do
        put :update
        subject.should redirect_to(new_user_merchant_path)
      end
    end
  end

  describe "for a user with a merchant" do
    let(:merchant)                  { double("Merchant") }
    let(:certificate_action_filter) { double("CertificateActionFilter") }
    let(:certificates)              { [double("Certificate")] }
    let(:params)                    { {'hi' => 'mate'} }

    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:merchant).and_return(merchant)
      CertificateActionFilter.stub(:new).and_return(certificate_action_filter)
      certificate_action_filter.should_receive(:certificates).and_return(certificates)

      sign_in(user)
    end

    def self.render_show
      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/certificates/show') }
      it { should assign_to(:merchant).with(merchant) }
      it { should assign_to(:certificate_action_filter).with(certificate_action_filter) }
      it { should assign_to(:certificates).with(certificates) }
    end

    describe "GET :show" do
      before do
        get :show
      end

      render_show
    end

    describe "PUT :update" do
      describe "to update" do
        describe "successfully" do
          before do
            certificate_action_filter.should_receive(:update!)
            put :update, :certificate_action_filter => params, :_update => true
          end

          it { should redirect_to(user_merchant_certificates_path) }
        end

        describe "unsuccessfully" do
          before do
            certificate_action_filter.should_receive(:update!).and_raise(AASM::InvalidTransition)
            put :update, :certificate_action_filter => params, :_update => true
          end

          render_show
          it { should set_the_flash.to("Certificates cannot transition from 'canceled'.") }
        end
      end

      describe "to filter" do
        before do
          certificate_action_filter.should_not_receive(:update!)
          put :update, :certificate_action_filter => params
        end

        render_show
      end
    end
  end

end

