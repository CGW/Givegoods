ActiveAdmin.register NewsletterSubscription do
  scope :all
  scope :merchant
  scope :charity
  scope :site
  
  filter :email
  
  index do
    column(:id)
    column(:type) {|r| r.source_type.to_s.titleize}
    column(:source) {|r| link_to truncate(r.source_name), [:admin, r.source || :dashboard]}
    column(:email)
    column(:created_at)
    default_actions
  end
  
end
