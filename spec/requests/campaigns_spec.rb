require_relative '../request_spec_helper'

feature 'Campaigns' do
  include CampaignExampleHelpers

  let(:campaign) { create_campaign_with_tier_taglines }
  let(:charity)  { campaign.charity }

  scenario 'allow the user to navigate back to the charities rewards page' do
    visit charity_campaign_default_path(charity, campaign.slug)
    page.should have_content(campaign.tagline)

    click_on 'Get Rewards When You Donate'

    page.should have_content("The rewards below directly support #{charity.name}")
    current_path.should eq(charity_merchants_path(charity))
  end

  scenario 'have errors when the form is submitted with incorrect information' do
    visit charity_campaign_default_path(charity, campaign.slug)
    page.should have_content("Donate to #{charity.name}")

    click_on 'Donate Now'

    page.should have_content("Donate to #{charity.name}")

    page.should have_content("The credit card entered has expired")
    page.should have_content("Please specify a donation amount between $1 and $10,000")
    page.should have_content("Please fill in your first name")
    page.should have_content("Please fill in your last name")
    page.should have_content("Please fill in your email address")
    page.should have_content("Please fill in your street address")
    page.should have_content("Please fill in your city")
    page.should have_content("Please fill in your state")
    page.should have_content("Please fill in your billing zip code")
    page.should have_content("You must accept the terms and conditions")
  end
  
  it "can be navigated to from a charities rewards page" do
    visit charity_merchants_path(charity)
    page.should have_selector('h1', :text => charity.name)

    click_on 'I want to skip rewards & donate now'

    # Donation page
    page.should have_content("Donate to #{charity.name}")
    page.should have_content(charity.campaign.tagline)
    page.should have_content("Yes, I want to donate $0.00 to #{charity.name}.")
  end

  describe 'allow a user to donate' do
    before do
      visit charity_campaign_path(charity, charity.campaign.slug)
      page.should have_content(charity.campaign.tagline)
    end

    scenario 'clears tier selections when setting a user specified donation amount' do
      tier = campaign.tiers.sample(1).first

      click_on "#{tier.amount.format(:no_cents_if_whole => true)}"
      page.should have_selector('button.btn-tier.btn-active', :text => tier.amount.format(:no_cents_if_whole => true))

      within "form.form-amount" do
        fill_in 'other_amount', :with => "15"
        click_on 'Submit'
      end

      # Filling in a customer amount should clear any previously chosen tiers
      campaign.tiers.each do |tier|
        page.should_not have_selector('button.btn-tier.btn-active', :text => tier.amount.format(:no_cents_if_whole => true))
      end
    end

    scenario 'a custom amount' do
      within "form.form-amount" do
        fill_in 'other_amount', :with => "15"
        click_on 'Submit'
      end
      page.should have_content("Yes, I want to donate $15.00 to #{charity.name}.")
      page.should have_field('donation_order[donation][amount]', :with => '15.00')

      complete_donation

      page.should have_content "Success"
      page.should have_content "You made the following charitable gift"
      page.should have_content Money.new(1500).format
    end

    scenario 'a specified tier amount' do
      # Tiers
      campaign.tiers.each do |tier|
        page.should have_button(tier.amount.format(:no_cents_if_whole => true))
      end

      tier = campaign.tiers.sample(1).first

      click_on "#{tier.amount.format(:no_cents_if_whole => true)}"
      page.should have_selector('button.btn-tier.btn-active', :text => tier.amount.format(:no_cents_if_whole => true))
      page.should have_field('donation_order[donation][amount]', :with => tier.amount.format(:symbol => false, :delimiter => false))
      page.should have_content("Yes, I want to donate $#{tier.amount} to #{charity.name}.")

      complete_donation

      page.should have_content "Success"
      page.should have_content "You made the following charitable gift"
      page.should have_content tier.amount.format
    end

    describe "after inputting incorrect credit card information" do
      scenario 'a donation can be made successfully' do
        within "form.form-amount" do
          fill_in 'other_amount', :with => "15"
          click_on 'Submit'
        end

        fill_in 'First Name',     :with => 'Galen'
        fill_in 'Last Name',      :with => 'Guenther'
        fill_in 'Email Address',  :with => 'galen@fake.net'

        # fail intentionally
        fill_in 'CC Number',                :with => 2
        select  (Date.today.year + 1).to_s, :from => 'CC Expiration'
        fill_in 'CVC',                      :with => 157
        fill_in 'Billing Zip Code',         :with => '94501'

        fill_in 'Street Address', :with => '1750 San Jose Ave.'
        fill_in 'City',           :with => 'Alameda'
        select 'California',      :from => 'State'

        check 'donation_order_customer_terms'
        click_on 'Donate Now'

        # Expect failure
        page.should have_content('Bogus Gateway: Forced failure')

        # Succeed now
        fill_in 'CC Number', :with => "\b1"
        click_on 'Donate Now'

        page.should have_content "Success"
        page.should have_content "You made the following charitable gift"
        page.should have_content Money.new(1500).format
      end
    end

    def complete_donation
      fill_in 'First Name',     :with => 'Galen'
      fill_in 'Last Name',      :with => 'Guenther'
      fill_in 'Email Address',  :with => 'galen@fake.net'

      fill_in 'CC Number',                :with => 1
      select  (Date.today.year + 1).to_s, :from => 'CC Expiration'
      fill_in 'CVC',                      :with => 157
      fill_in 'Billing Zip Code',         :with => '94501'

      fill_in 'Street Address', :with => '1750 San Jose Ave.'
      fill_in 'City',           :with => 'Alameda'
      select 'California',      :from => 'State'

      check 'I agree to the Terms and Conditions'

      click_on 'Donate Now'
    end
  end
end
