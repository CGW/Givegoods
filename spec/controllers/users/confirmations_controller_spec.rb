require 'spec_helper'

describe Users::ConfirmationsController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET :new" do
    before do
      get :new
    end

    it { should respond_with(:success) }
    it { should render_template('layouts/bootstrap/application') }
    it { should render_template('users/confirmations/new') }
    it { should assign_to(:title).with("Resend confirmation :: #{I18n.t("site.title")}") }
  end

  describe "GET :sent" do
    before do
      flash = mock('Flash')
      subject.should_receive(:flash).and_return(flash)
      flash.should_receive(:delete).with(:notice)

      get :sent
    end

    it { should render_template('layouts/bootstrap/application') }
    it { should render_template('users/confirmations/sent') }
  end

end
