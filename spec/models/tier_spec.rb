require 'spec_helper'

describe Tier do
  include CampaignExampleHelpers

  subject { Tier.new(:as => :admin) }

  [:amount, :tagline].each do |attr|
    #it { should allow_mass_assignment_of(attr).as(:admin) }
    it { should allow_mass_assignment_of(attr) }
  end

  it { should belong_to(:campaign) }

  include_examples "money attribute validations", :amount, 1, 10000
  it { should_not allow_value(0).for(:amount).with_message('Amount must be between $1 and $10,000') }

  it { should ensure_length_of(:tagline).is_at_most(255).with_long_message(/is too long/) }
  
  describe "uniqueness validators" do
    before do
      # We need a tier record for validates uniqueness tests  
      create_campaign_with_tier_taglines
    end
    it { should validate_uniqueness_of(:amount_cents).scoped_to(:campaign_id).with_message('A tier with the amount you specified already exists') }
  end

end
