ActiveAdmin.register Bundle do
  scope :all
  scope :active
  scope :inactive

  # Note that this causes ActiveAdmin to perform a "SELECT * FROM charities", so
  # when the DB grows this will be SLOW. Hopefully ActiveAdmin will be fixed by
  # that point but if not, now you've been warned.
  #
  # For context:
  #
  # https://github.com/gregbell/active_admin/issues/1026
  # https://github.com/bvision/givegoods_site/issues/114
  filter :charity
  filter :donation_value_cents
  filter :created_at
  filter :updated_at

  form :partial => "form"

  index do
    column(:preview) do |resource|
      link_to(image_tag(resource.image_url(:small), :size => "50x50"), [:admin, resource])
    end
    column(:status) {|r| resource_status_tag(r)}
    column :name
    column(:charity) do |resource|
      link_to(resource.charity.name, [:admin, resource.charity])
    end
    column :donation_value
    column do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource),
        :method => :delete, :class => "member_link delete_link", :confirm => "Are you really really really sure?"
      links
    end
  end

  collection_action :autocomplete_merchant_name

  controller do
    autocomplete :merchant, :name, :display_value => :offer_to_s, :scopes => [:active], :full => true
  end

  show do
    panel "Bundle Details" do
      attributes_table_for resource do
        row :id
        row :charity do
          resource.charity.name
        end
        row :donation_value
        row :name
        row :tagline
        row :notes
        row :image do
          image_tag(resource.image_url(:small), :size => "50x50")
        end
        row :status do resource_status_tag(resource) end
        row :created_at
        row :updated_at
      end
    end

    panel "Bundle offers" do
      if resource.offers.any?
        offers = resource.offers
        attributes_table_for bundle do
          offers.each_with_index do |offer, i|
            row(i+1) { offer.to_s }
          end
        end
      else
        span "No offer found."
      end
    end
  end

end
