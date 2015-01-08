class Users::RegistrationsController < Devise::RegistrationsController

  ssl_required :new, :create, :edit, :update
  before_filter :set_title, only: [:new, :create]

  layout :set_layout

  protected

  def after_inactive_sign_up_path_for(resource)
    user_confirmation_sent_path
  end

  def after_update_path_for(reource)
    edit_user_registration_path
  end

  def set_title
    @title = "Sign Up :: #{t("site.title")}"
  end

  def set_layout
    case action_name
    when 'new', 'create'
      "bootstrap/application"
    when 'edit', 'update'
      "bootstrap/users"
    end
  end
end
