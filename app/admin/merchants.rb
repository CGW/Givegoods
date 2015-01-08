ActiveAdmin.register Merchant do
  scope :all
  scope :unconfirmed
  scope :pending
  scope :active
  scope :suspended

  filter :name
  filter :description
  filter :website_url
  filter :status
  filter :created_at
  filter :updated_at
  filter :registered_at
  filter :activated_at

  after_create do |merchant|
    [:register, :activate].each do |event|
      merchant.send("#{event}!") if !merchant.new_record? && merchant.aasm_events_for_current_state.include?(event)
    end
  end
  
  collection_action :autocomplete_charity_name
  controller do
    autocomplete :charity, :name, :extra_data => [:id], :scopes => [:active]
  end
  
  index do
    column(:preview) do |resource|
      link_to(image_tag(resource.picture_url(:small), :size => "50x50"), [:admin, resource])
    end
    column(:name) do |resource|
      link_to(resource.name, [:admin, resource])
    end
    column(:status) {|r| resource_status_tag(r)}
    column(:website_url) {|r| link_to(r.website_url, url_for(r.website_url), "data-popup" => true)}
    # default_actions
    column do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), 
        :method => :delete, :class => "member_link delete_link", :confirm => "Are you really really really sure?"
      resource.aasm_events_for_current_state.each do |event|
        links += link_to I18n.t("active_admin.#{event}"), event_admin_merchant_path(resource, :name => "#{event}"), 
          :class => "member_link #{event}_link"
      end
      links
    end
  end
  
  member_action :event do
    resource.send("#{params[:name]}!")
    redirect_to request.referrer
  end

  member_action :merchant_offer

  action_item :only => [:edit, :show] do
    links = ""
    resource.aasm_events_for_current_state.each do |event|
      links += link_to I18n.t("active_admin.#{event}"), event_admin_merchant_path(resource, :name => "#{event}")
    end
    links.html_safe
  end
  
  form :partial => "form"
  
  show do
    panel "Merchant Details" do
      attributes_table_for resource do
        row :id
        row :user
        row :name
        row :description
        row :picture do 
          image_tag(resource.picture_url(:small), :size => "50x50")
        end
        row :website_url
        row :created_at
        row :updated_at
        row :slug
        row :status do resource_status_tag(resource) end
        row :lat
        row :lng
        row :registered_at
        row :activated_at
      end
    end

    panel "Address" do
      if resource.address
        attributes_table_for resource.address do
          row :phone
          row :street
          row :city
          row :province
          row :postal_code
          row :country
        end
      else
        span "No address found."
      end
    end

    panel "Offer Settings" do
      if offer = resource.offer
        attributes_table_for offer do
          row :status do resource_status_tag(offer) end
          row :discount_rate
          row :offer_cap
          row :max_certificates
          row :tagline
          row :rules
          row :supported_charities do
            case offer.charity_selection
              when :near then "near #{offer.charities_near}"
              when :one then "#{offer.charity.name}"
            else
              "#{offer.charity_selection}".humanize
            end
          end
          row :lat
          row :lng
        end
      else
        span "No offer created."
      end
    end
  end

end
