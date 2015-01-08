class CharityObserver < ActiveRecord::Observer
  def after_create(charity)
    create_campaign(charity)
  end

  private 

  def create_campaign(charity)
    return if charity.campaign.present?
    charity.create_campaign(
      :tagline          => "Make a contribution to #{charity.name}",
      :slug             => "donate",
      :tiers_attributes => [
        { :amount => 25 },
        { :amount => 50 },
        { :amount => 100 },
        { :amount => 250 },
      ]
    )
  end
end
