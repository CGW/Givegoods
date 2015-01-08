
class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "bootstrap/application"

  ssl_required :new, :create, :sent

  def new
    @title = "Resend confirmation :: #{t("site.title")}"
    super
  end

  def sent
    # Devise automatically adds a notice about confirmation after a register
    # registers; we don't need to use it.
    flash.delete :notice
  end
end
