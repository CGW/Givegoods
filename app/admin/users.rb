ActiveAdmin.register User do
  scope :all
  scope :unconfirmed
  scope :active

  filter :email
  filter :facebook_uid
  filter :created_at
  filter :updated_at
  filter :confirmed_at
  filter :confirmation_sent_at

  before_save do |user|
    user.skip_confirmation! 
  end

  after_create do |user|
    [:register, :activate].each do |event|
      if user.merchant && !user.merchant.new_record? && user.merchant.aasm_events_for_current_state.include?(event)
        user.merchant.send("#{event}!")
      end
    end
  end
  
  index do
    column(:email)
    column(:role)
    column(:resource) do |resource|
      if resource.merchant
        link_to(resource.merchant.name, [:admin, resource.merchant])
      elsif resource.charity
        link_to(resource.charity.name, [:admin, resource.charity])
      end
    end
    column(:status) do |resource|
      resource.confirmed? ? status_tag('active', :ok) : status_tag('unconfirmed', :warning)
    end
    column do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource),
        :method => :delete, :class => "member_link delete_link", :confirm => "Are you really really really sure?"
      unless resource.confirmed?
        links += link_to "Resend confirmation email", resend_confirmation_admin_user_path(resource), :class => "member_link edit_link"
      else
        links += link_to "Sign in", login_admin_user_path(resource), :class => "member_link edit_link"
      end
      links
    end
  end

  form :partial => "form"

  member_action :resend_confirmation, :method => :get do
    user = User.find(params[:id])
    user.resend_confirmation_token
    redirect_to({ :action => :index }, :notice => "Confirmation email sent to #{user.email}")
  end

  member_action :login, :method => :get do
    user = User.find(params[:id])
    sign_in(user)
    redirect_to edit_user_merchant_path
  end

end
