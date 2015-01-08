
class Users::SessionsController < Devise::SessionsController
  layout "bootstrap/application"

  ssl_required :new, :create
  before_filter :set_user_params, :only => [:create]

  private

  def set_user_params
    # Our login form may pass user_session rather than user.
    params[:user] ||= params[:user_session]
  end
end
