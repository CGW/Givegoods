ActiveAdmin.register_page "Mailer Previews" do 
  menu :label => "Preview emails", :parent => "Other"

  sidebar "Preview an email" do
    div strong "Users"
    ul do
      li link_to('Confirmation Instructions', show_admin_mailer_preview_path(:user_confirmation_instructions))
    end
    div strong "Orders"
    ul do
      li link_to('Paid / receipt (with rewards)', show_admin_mailer_preview_path(:order_paid_with_rewards))
      li link_to('Paid / receipt (w/o rewards)', show_admin_mailer_preview_path(:order_paid_without_rewards))
    end
  end

  content do
    "Select mailer from the sidebar to view a preview of it."
  end

  controller do
    def show 
      mailer_method = params[:id].to_sym
      unless respond_to?(mailer_method)
        redirect_to admin_mailer_previews_path
        return
      end

      self.send(mailer_method)
    end

    def user_confirmation_instructions
      @mail = Devise::Mailer.confirmation_instructions(User.last)
      render :layout => 'mailers/preview'
    end

    def order_paid_with_rewards
      @mail = OrderMailer.paid(Certificate.last.customer.orders.first)
      render :layout => 'mailers/preview'
    end

    def order_paid_without_rewards
      @mail = OrderMailer.paid(Donation.where("? IS NOT NULL", :charity_id).last.order)
      render :layout => 'mailers/preview'
    end
  end

end
