require_relative '../request_spec_helper'

feature 'Users with charity role' do
  let(:user) { create(:user, :charity) }

  describe 'without a charity' do
    before do
      visit new_user_session_path

      fill_in 'user_session[email]',    :with => user.email
      fill_in 'user_session[password]', :with => 'change-this'

      click_on 'Log in'
      page.should have_link('My Account')
    end

    scenario 'can create a charity' do
      # Should force us to create charity
      page.should have_content('Create your charity profile')

      fill_in 'Charity name',  :with => 'Alameda Meals on Wheels'
      fill_in 'EIN',           :with => '000000000000'
      fill_in 'Website URL',   :with => 'http://www.amow.org'
      fill_in 'Zip',           :with => '94501'

      click_on 'Create charity'

      page.should have_content("Congratulations, Alameda Meals on Wheels.")
    end
  end

  describe 'with a charity' do
    before do
      login_as(user, :scope => :user)
    end

    describe 'that is inactive' do
      let!(:charity) { create(:inactive_charity, :user => user) }

      before do
        visit edit_user_charity_path
        page.should have_content 'Almost Finished'

        page.should have_selector('.alert-policy-status', :text => /^COMPLETE$/, :count => 1)
        page.should have_selector('.alert-policy-status', :text => /^INCOMPLETE$/, :count => 3)
      end

      scenario 'must complete required items for activation' do
        attach_file('Picture', File.expand_path("#{Rails.root}/test/fixtures/files/charities/save-the-redwoods.jpg", __FILE__))
        click_on 'Update charity'

        page.should have_selector('.alert-policy-status', :text => /^COMPLETE$/, :count => 2)
        page.should have_selector('.alert-policy-status', :text => /^INCOMPLETE$/, :count => 2)

        fill_in 'Description', :with => 'My charity cares about animals, life, and community.'
        click_on 'Update charity'

        page.should have_selector('.alert-policy-status', :text => /^COMPLETE$/, :count => 3)
        page.should have_selector('.alert-policy-status', :text => /^INCOMPLETE$/, :count => 1)


        fill_in 'Contact email', :with => 'contact@charity.org'
        fill_in 'Phone', :with => '510.522.5138'
        fill_in 'Street', :with => '1416 Broadway Ave.'
        fill_in 'City', :with => 'Alameda'
        select 'California', :from => 'State'
        click_on 'Update charity'

        page.should have_content('Givegoods is reviewing your account and will activate your account very soon.') 
        page.should have_content('Edit charity profile')
      end
    end

    describe 'that is active' do
      let!(:charity) { create(:active_charity, :user => user) }

      before do
        visit edit_user_charity_path
        page.should have_content 'Edit charity profile'
      end

      scenario 'can update the profile' do
        fill_in 'EIN',         :with => '1010101010'
        fill_in 'Description', :with => 'An updated description'

        click_on 'Update charity'

        page.should have_content 'Your charity profile has been updated.'

        page.should have_field 'EIN',         :with => '1010101010'
        page.should have_field 'Description', :with => 'An updated description'
      end

      scenario 'cannot remove active charity policy fields' do
        ['Contact email', 'Description', 'Phone', 'Street', 'City'].each do |field|
          fill_in field, :with => ''
        end
        select '', :from => 'State'

        click_on 'Update charity'

        ['Contact email', 'Description', 'Phone', 'Street', 'City', 'State'].each do |field|
          page.should have_content "#{field} can't be blank"
        end
      end

      describe 'donation campaign settings' do
        let(:campaign) { charity.campaign }

        before do
          click_on 'Donation page'
          page.should have_content('Personalize your donation page for your donors.')
        end

        scenario 'can update basics' do
          fill_in 'Tagline', :with => 'Feeding Alameda is our priority'
          click_on 'Update'

          page.should have_content 'Your donation page has been updated.'
          page.should have_field('Tagline', :with => 'Feeding Alameda is our priority')
        end

        scenario 'can add a tier' do
          new_element_index = campaign.tiers.count

          fill_in 'Add new tier', :with => '69.00'
          fill_in "campaign_tiers_attributes_#{new_element_index}_tagline", :with => "Sup son?"

          click_on 'Update'

          page.should have_xpath("//input[@type='text']", :with => "69.00")
          page.should have_xpath("//input[@type='text']", :with => "Sup son?")
        end

        scenario 'can update tiers' do
          campaign.tiers.each_with_index do |tier, index|
            amount_string = (tier.amount - Money.new(500)).format(:symbol => false)
            fill_in "Tier ##{index+1}", :with => amount_string
            fill_in "campaign_tiers_attributes_#{index}_tagline", :with => "Placeholder #{tier.id}"
          end

          click_on 'Update'

          campaign.reload.tiers.each_with_index do |tier, index|
            page.should have_field("Tier ##{index+1}", :with => tier.amount.format(:symbol => false))
            page.should have_field("campaign_tiers_attributes_#{index}_tagline", :with => "Placeholder #{tier.id}")
          end
        end

        scenario 'can delete a tier' do
          tier = campaign.tiers.sample(1).first
          dom_selector = "#tier_#{tier.id}"
          within dom_selector do
            check 'Delete'
          end

          click_on 'Update'

          page.should_not have_selector(dom_selector)
        end
      end
    end
  end
end
