require_relative '../request_spec_helper'

feature 'Charity landing page' do
  let(:charity) { create(:active_charity) }

  scenario "allows user to navigate to the charity's rewards page" do
    visit charity_landing_path(charity)
    page.should have_content "Donate to #{charity.name}"

    click_on "Donate With Rewards"

    page.should have_content "The rewards below directly support #{charity.name}"
  end

  scenario "allows user to navigate to the charity's campaign page" do
    visit charity_landing_path(charity)
    page.should have_content "Donate to #{charity.name}"

    click_on "Donate Without Rewards"

    page.should have_content "Donate to #{charity.name}"
    page.should have_content "#{charity.campaign.tagline}"
  end
end
