ActiveAdmin.register Certificate do
  scope :all
  scope :unredeemed
  scope :redeemed
  scope :canceled

  filter :amount_cents
  filter :status
  filter :code

  index do
    column(:merchant) do |resource|
      if resource.merchant
        link_to(image_tag(resource.merchant.picture_url(:small), :size => "50x50"), [:admin, resource.merchant])
      else
        span("deleted", :class => "empty")
      end
    end
    column(:charity) do |resource|
      if resource.charity
        link_to(image_tag(resource.charity.picture_url(:small), :size => "50x50"), [:admin, resource.charity])
      else
        span("deleted", :class => "empty")
      end
    end
    column(:code)   { |r| link_to(r.code, print_certificate_url(r)) }
    column(:amount) { |r| r.amount.format}
    column(:status) { |r| resource_status_tag(r)}
    # default_actions
    column do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource),
        :method => :delete, :class => "member_link delete_link", :confirm => "Are you really really really sure?"
      resource.aasm_events_for_current_state.each do |event|
        links += link_to I18n.t("active_admin.#{event}"), event_admin_certificate_path(resource, :name => "#{event}"),
          :class => "member_link #{event}_link"
      end
      links
    end
  end

  member_action :event do
    resource.send("#{params[:name]}!")
    redirect_to request.referrer
  end

  show do
    panel "Certificate Details" do
      attributes_table_for resource do
        row :id
        row :code do |r|
          link_to(r.code, print_certificate_url(r))
        end
        row :customer
        row :charity
        row :merchant
        row :amount do
          "#{resource.amount.format}, #{resource.currency}"
        end
        row :status
        row :created_at
      end
    end
  end
end
