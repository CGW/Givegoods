require 'spec_helper'

describe 'donation_orders/_form' do
  include CampaignExampleHelpers

  let!(:campaign)       { create_campaign_with_tier_taglines }
  let!(:charity)        { campaign.charity }
  let!(:donation_order) { DonationOrder.new }

  it "has a form for a new donation order" do
    render :partial => 'donation_orders/form', :locals => { :charity => charity, :campaign => campaign, :donation_order => donation_order }

    rendered.should have_selector("form", :method => "post",
                                  :action => charity_campaign_donation_orders_path(charity, campaign))
  end

  describe "error messaging" do
    let(:error) { "An error on" }

    [
      "payment",
      "donation.amount",
      "customer.first_name",
      "customer.email",
      "customer.billing_address.postal_code",
      "customer.terms"
    ].each do |field|
      it "shows the error for #{field}" do
        donation_order.errors.add field, "#{error} #{field}"
        render :partial => 'donation_orders/form', :locals => { :charity => charity, :campaign => campaign, :donation_order => donation_order }

        rendered.should have_content('Oops! There was a few problems with the information you gave us')
        rendered.should have_selector('ul li', :text => "#{error} #{field}")
      end
    end
  end

  describe "donation tiers" do
    it "has radio buttons with tagline" do
      render :partial => 'donation_orders/form', :locals => { :charity => charity, :campaign => campaign, :donation_order => donation_order }

      campaign.tiers.each do |tier|
        rendered.should have_unchecked_field("#{tier.amount.format(:no_cents_if_whole => true)}: #{tier.tagline}")
        rendered.should have_field('donation_order[donation][tier_amount]', :type => :radio, :with => tier.amount.format(:symbol => false))
      end
    end

    it "has radio buttons without tagline" do
      campaign.tiers.each do |tier|
        tier.update_attributes!(:tagline => nil)
      end
      render :partial => 'donation_orders/form', :locals => { :charity => charity, :campaign => campaign, :donation_order => donation_order }

      campaign.tiers.each do |tier|
        rendered.should have_unchecked_field("#{tier.amount.format(:no_cents_if_whole => true)}")
        rendered.should have_field('donation_order[donation][tier_amount]', :type => :radio, :with => tier.amount.format(:symbol => false))
      end
    end
    it "has a donation / user specified amount field" do
      donation_order.donation.amount = 15
      render :partial => 'donation_orders/form', :locals => { :charity => charity, :campaign => campaign, :donation_order => donation_order }
      rendered.should have_field('Or, donate any amount')
      rendered.should have_field('donation_order[donation][amount]', :type => :input, :with => "15.00")
    end
  end

  describe "customer and billing fieldsets" do
    before do
      render :partial => 'donation_orders/form', :locals => { :charity => charity, :campaign => campaign, :donation_order => donation_order }
    end

    it "has customer info fields" do
      rendered.should have_field("First Name")
      rendered.should have_field("Last Name")
      rendered.should have_field("Email Address")
      rendered.should have_field("Street Address")
      rendered.should have_field("City")
      rendered.should have_select("State", :with_options => Region.all.map(&:name))

      [:first_name, :last_name, :email].each do |attr|
        rendered.should have_field("donation_order[customer][#{attr}]")
      end
      [:street, :city].each do |attr|
        rendered.should have_field("donation_order[customer][billing_address_attributes][#{attr}]")
      end
      rendered.should have_select("donation_order[customer][billing_address_attributes][state_code]", :with_options => Region.all.map(&:name))
      rendered.should have_xpath("//input[@name='donation_order[customer][billing_address_attributes][country_code]' and @type='hidden' and @value='US']")
    end

    it "has billing info fields" do
      rendered.should have_select("CC Type", :with_options => MerchantSidekick::default_gateway.supported_cardtypes.map {|t| ["#{t}".titleize, t]})
      rendered.should have_field("CC Number")
      rendered.should have_field("CVC")
      rendered.should have_field("Billing Zip Code")

      rendered.should have_select("donation_order[credit_card][type]", :with_options => MerchantSidekick::default_gateway.supported_cardtypes.map {|t| ["#{t}".titleize, t]})
      [:number, :year, :verification_value].each do |attr|
        rendered.should have_field("donation_order[credit_card][#{attr}]")
      end
      rendered.should have_field("donation_order[customer][billing_address_attributes][postal_code]")

      rendered.should have_select("donation_order[credit_card][month]", :with_options => (1..12).collect{ |n| "#{n} - #{I18n.t('date.month_names')[n]}" })
      rendered.should have_select("donation_order[credit_card][month]", :with_options => Date.today.year..Date.today.year+7)
    end

    it "has terms field" do
      rendered.should have_unchecked_field('I agree to the Terms and Conditions')
    end

    it "has anonymous field" do
      rendered.should have_unchecked_field('I wish to keep my donation anonymous')
    end

    it "has the donate now button" do
      rendered.should have_button('Donate Now')
    end
  end
end
