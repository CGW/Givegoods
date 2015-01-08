
class CampaignStat

  attr_reader :campaign

  def initialize(attributes = {})
    attributes.each do |attr, value|
      self.send(:"#{attr}=", value)
    end

    @campaign ||= Campaign.new
  end

  def campaign=(campaign)
    return unless campaign.is_a?(Campaign)
    @campaign = campaign
  end

  def donations_count 
    valid_donations.count
  end

  def donations_amount_cents_sum
    valid_donations.sum(:amount_cents)
  end

  def donations_amount_sum
    Money.new(donations_amount_cents_sum)
  end

  def self.for(campaign)
    return nil unless campaign.is_a?(Campaign)
    CampaignStat.new(:campaign => campaign)
  end

  protected 

  def valid_donations
    @scope ||= campaign.donations.successful.where("amount_cents >= 500")
  end
end
