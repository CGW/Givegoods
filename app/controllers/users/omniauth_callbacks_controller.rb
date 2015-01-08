class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_or_create_from_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      render 'users/registrations/new'
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end