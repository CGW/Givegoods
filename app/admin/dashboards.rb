ActiveAdmin::Dashboards.build do

  section "Statistics", :priority => 1 do
    ul do
      li do
        "Redeemed certificates %s worth %s" % [Certificate.redeemed.count, Money.new(Certificate.redeemed.sum(:amount_cents)).format]
      end
      li do
        "Unredeemed certificates %s worth %s" % [Certificate.unredeemed.count, Money.new(Certificate.unredeemed.sum(:amount_cents)).format]
      end
      li do
        "Purchases %s worth %s" % [MerchantSidekick::PurchaseOrder.approved.count, Money.new(MerchantSidekick::PurchaseOrder.approved.sum(:gross_cents)).format]
      end
    end
  end

  section "Merchants waiting for approval" do
    table_for Merchant.pending.recent(5) do |t|
      column(:thumbnail) do |resource|
        link_to(image_tag(resource.picture_url(:small), :size => "50x50"), [:admin, resource])
      end
      t.column(:name) {|r| link_to(r.name, [:admin, r])}
      t.column(:status) {|r| resource_status_tag(r)}
    end
    div do
      link_to "See more...", admin_merchants_path(:scope => "pending")
    end
  end
  
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
