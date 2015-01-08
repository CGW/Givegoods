ActiveAdmin.register Charity do
  scope :all
  scope :active
  scope :inactive
  scope :with_picture
  scope :without_picture

  filter :name
  filter :description
  filter :created_at
  filter :updated_at
  filter :website_url
  filter :ein

  index do
    column(:preview) do |resource|
      link_to(image_tag(resource.picture_url(:small), :size => "50x50"), [:admin, resource])
    end
    column(:name) do |resource|
      link_to(resource.name, [:admin, resource])
    end
    column(:website_url) {|r| link_to(truncate(r.website_url), url_for(r.website_url), "data-popup" => true)}
    # default_actions
    column do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource),
        :method => :delete, :class => "member_link delete_link", :confirm => "Are you really really really sure?"
      resource.aasm_events_for_current_state.each do |event|
        links += link_to I18n.t("active_admin.#{event}"), event_admin_charity_path(resource, :name => "#{event}"),
          :class => "member_link #{event}_link"
      end
      links
    end
  end

  member_action :event do
    resource.send("#{params[:name]}!")
    redirect_to request.referrer
  end

  action_item :only => [:edit, :show] do
    links = ""
    resource.aasm_events_for_current_state.each do |event|
      links += link_to I18n.t("active_admin.#{event}"), event_admin_charity_path(resource, :name => "#{event}")
    end
    links.html_safe
  end

  form :partial => "form"

  show do
    panel "Charity Details" do
      attributes_table_for resource do
        row :id
        row :user do
          unless resource.user.present?
            span("Orphaned", :class => "empty")
          else 
            link_to resource.user.email, admin_user_path(resource.user)
          end
        end
        row :name
        row :slug
        row :lat
        row :lng
        row :picture do
          image_tag(resource.picture_url(:small), :size => "50x50")
        end
        row :website_url
        row :description
        row :campaign_bundle_tagline
        row :ein
        row :temp_image_url do
          unless resource.temp_image_url.blank?
            div(resource.temp_image_url)
            image_tag(resource.temp_image_url, :size => "50x50")
          else
            span("Empty", :class => "empty")
          end
        end
        row :temp_image_url2 do
          unless resource.temp_image_url2.blank?
            div(resource.temp_image_url2)
            image_tag(resource.temp_image_url2, :size => "50x50")
          else
            span("Empty", :class => "empty")
          end
        end
        row :metro_area_name
        row :created_at
        row :updated_at
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

    panel "Featured Merchants" do
      if resource.featured_merchants.any?
        span resource.featured_merchants.map(&:name).join(', ')
      else
        span "No merchants are blocked."
      end
    end

    panel "Blocked Merchants" do
      if resource.blocked_merchants.any?
        merchants = resource.blocked_merchants
        attributes_table_for charity do
          merchants.each_with_index do |merchant, i|
            row(i+1) { merchant.name }
          end
        end
      else
        span "No merchants are blocked."
      end
    end
  end

  collection_action :autocomplete_merchant_name
  controller do
    autocomplete :merchant, :name, :extra_data => [:id], :scopes => [:active], :full => true
  end

end
