
class Users::PasswordsController < Devise::PasswordsController

  ssl_required :new, :create

  layout "bootstrap/application"

  def new
    @title = "Reset password :: #{t("site.title")}"
    super
  end

end
