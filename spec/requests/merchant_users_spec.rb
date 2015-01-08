require_relative '../request_spec_helper'

feature 'Users with merchant role' do
  let(:user) { create(:user, :merchant) }

  describe 'without a merchant' do
    before do
      visit new_user_session_path

      fill_in 'user_session[email]',    :with => user.email
      fill_in 'user_session[password]', :with => 'change-this'

      click_on 'Log in'
      page.should have_link('My Account')
    end

    scenario 'can create a merchant' do
      # Should force us to create merchant
      page.should have_content('Create your merchant profile')

      fill_in 'Name',        :with => "Runnation"
      fill_in 'Website URL', :with => 'http://www.runnation.com'
      fill_in 'Zip',         :with => '94501'

      click_on 'Create merchant'

      page.should have_content("Your merchant has been created and has been submitted for review by our team.")
      page.should have_content("Merchant profile")
    end
  end

  describe 'with a merchant' do
    let!(:merchant) { create(:merchant, :user => user) }

    before do
      login_as(user, :scope => :user)

      # Take us to a basic position
      visit edit_user_merchant_path
      page.should have_content 'Merchant profile'
    end

    scenario 'can update the profile' do
      fill_in 'Description', :with => 'An updated description'
      fill_in 'Phone',       :with => '510-522-5148'
      fill_in 'City',        :with => 'Alameda'
      select 'California',   :from => 'State'

      click_on 'Update merchant'

      page.should have_content 'Your merchant profile has been updated.'

      page.should have_field('Description', :text => 'An updated description')
      page.should have_field('Phone', :text => '510-522-5148')
      page.should have_field('City', :text => 'Alameda')
      page.should have_field('State', :text => 'California')
    end

    describe 'reward settings' do
      scenario 'can be created' do
        click_on 'Reward settings'
        page.should have_content('Reward settings')

        select 'active',                :from => 'Status'
        select '50%',                   :from => 'Reward discount'
        fill_in 'Tagline',              :with => 'Get 50% off any thing with stuff.'
        fill_in 'Rules and conditions', :with => 'Limit 1 per customer'

        click_on 'Save reward settings'

        page.should have_content 'Your reward has been successfully created.'

        page.should have_field('Status', :text => 'active')
        page.should have_field('Reward discount', :text => '50%')
        page.should have_field('Tagline', :text => 'Get 50% off any thing text stuff.')
        page.should have_field('Rules and conditions', :text => 'Limit 1 per customer')
      end

      scenario 'can be updated' do
        charity = create(:active_charity, :name => "Alameda Super Kids")
        merchant.offer = create(:offer)
        merchant.save!

        click_on 'Reward settings'
        page.should have_content('Reward settings')

        select 'paused', :from => 'Status'
        fill_in 'Reward value limit', :with => "100"

        # One charity selection is tricky autocomplete
        choose 'One charity named:'
        fill_in 'offer[charity_name]', :with => "Alameda "
        #wait for autocomplete to catch up
        sleep(3)
        # find the item in the list
        page.execute_script "$('.ui-menu-item a:contains(\"#{charity.name}\")').trigger('mouseenter').click();"

        click_on 'Save reward settings'

        page.should have_field('Status', :text => 'paused')
        page.should have_field('Reward value limit', :text => '100.00')
        page.should have_checked_field('One charity named:')
        page.should have_field('offer[charity_name]', :text => 'Alameda Super Kids')
      end
    end

    describe "purchase history" do
      let(:certificates) { create_list(:certificate, 3, :merchant => merchant) }
      let!(:certificate) { certificates.first }
      
      scenario 'can update certificate statuses' do
        click_on 'Purchase history'
        select 'Redeemed', :from => 'Mark selected as'

        within 'tr', :text => /#{certificate.code}/ do
          page.should have_content('unredeemed')
          check "certificate_action_filter[selected][]"
        end

        page.find(:xpath, '//input[@name="_update"]').click

        within 'tr', :text => /#{certificate.code}/ do
          page.should have_content('redeemed')
        end
      end
      
      scenario 'can filter certificates by status' do
        certificate.status = 'canceled'
        certificate.save!

        click_on 'Purchase history'

        select 'Canceled', :from => 'Filter by status'
        page.find(:xpath, '//input[@name="_filter"]').click

        page.should have_content(certificate.code)
        certificates.each do |c|
          next if c == certificate
          page.should_not have_content(c.code)
        end
      end
    end
  end
end
