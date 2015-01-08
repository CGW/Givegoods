ActiveAdmin.register Campaign do
  index do 
    column(:preview) do |resource|
      link_to(image_tag(resource.charity.picture_url(:small), :size => "50x50"), [:admin, resource])
    end
    column(:name) do |resource|
      link_to(resource.name, [:admin, resource])
    end
    column :tagline
    default_actions
  end

  show do |c|
    attributes_table do
      row :id
      row :charity
      row :slug
      row :name
      row :tagline
      row :created_at
      row :updated_at
    end

    panel "Campaign Statistics" do
      attributes_table_for c do
        row :number_of_donors do 
          c.donations.successful.count
        end
        row :amount_raised do 
          Money.new(c.donations.successful.sum(:amount_cents))
        end
      end
    end

    panel "Tiers" do
      if resource.tiers.any?
        table_for resource.tiers do
          column :amount
          column :tagline
        end
      else
        span "No tiers have been configured."
      end
    end
  end

  form do |f|
    f.inputs "Details" do
      if f.object.new_record?
        f.input :charity
      else 
        f.input :name, :input_html => { :disabled => true, :value => f.object.name }
      end
      f.input :slug
      f.input :tagline
    end

    f.buttons

    f.has_many :tiers do |tier_f|
      tier_f.input :amount
      tier_f.input :tagline

      if !tier_f.object.nil?
        tier_f.input :_destroy, :as => :boolean, :label => "Destroy?"
      end
    end
  end
end

