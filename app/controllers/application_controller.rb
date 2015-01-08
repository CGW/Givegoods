class ApplicationController < ActionController::Base

  protect_from_forgery

  def self.ssl_required(*secure_actions)
    before_filter :require_ssl, only: secure_actions
  end


  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      return admin_dashboard_path
    end

    unless resource.role
      return new_user_role_assignment_path
    end

    case resource.role
    when 'charity' 
      return new_user_charity_path
    when 'merchant'
      return new_user_merchant_path
    end
  end

  protected

  def require_ssl
    return true unless Rails.application.config.ssl_enabled
    redirect_to protocol: "https" unless request.ssl?
  end

end
