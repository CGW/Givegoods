require 'spec_helper'

describe Users::PasswordsController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET :new" do
    before do
      get :new
    end

    it { should respond_with(:success) }
    it { should render_template('layouts/bootstrap/application') }
    it { should render_template('users/passwords/new') }
    it { should assign_to(:title).with("Reset password :: #{I18n.t("site.title")}") }
  end

end
