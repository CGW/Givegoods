require 'spec_helper'

describe 'donation_orders/_form_fields_info' do
  include CampaignExampleHelpers

  let!(:campaign)       { create_campaign_with_tier_taglines }
  let!(:charity)        { campaign.charity }
  let!(:donation_order) { DonationOrder.new }
  let(:form)  { ActionView::Helpers::FormBuilder.new(:donation_order, donation_order, view, {}, nil) }

  describe "customer and billing fieldsets" do
    before do
      render :partial => 'donation_orders/form_fields_info', :locals => { :form => form, :charity => charity, :campaign => campaign, :donation_order => donation_order }
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
      
      rendered.should have_select("donation_order[customer][billing_address_attributes][province_code]", :with_options => Region.all.map(&:name))
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
  end
end
