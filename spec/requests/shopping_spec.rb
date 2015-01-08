require_relative '../request_spec_helper'

feature 'Shopping' do
  let!(:lat_lng)   { {lat: 37.7913290, lng: -122.4005380} } 
  let!(:charities) { create_list(:active_charity, 6) }
  let!(:offers)    { create_list(:offer, 6) }
  let!(:charity)   { charities.sample }
  let!(:offer)     { offers.sample }
  # Merchant object is not away of the offer until reload; 
  let!(:merchant)  { offer.merchant.reload }

  background do
    offers.map(&:merchant).each do |merchant|
      merchant.lat = charity.lat
      merchant.lng = charity.lng
      merchant.save!
    end
  end

  def assert_lightbox_has_offer_and_charity(offer, charity)
    wait_until_element_exists "#lightbox" do
      page.should have_content('About This Reward')

      page.should have_selector('.lightbox-text', :text => "to #{charity.name}")
      page.should have_selector('.lightbox-text', :text => "at #{offer.merchant.name}")

      click_on 'Add to cart'
    end
  end

  def assert_cart_has_offer_and_buy(offer)
    wait_until_element_exists "#cart" do 
      # Cart slides up, so we need to wait until it's done.
      wait_until { page.find('a', :text => 'Give Now').visible? }

      page.should have_content('Select more rewards or give now')
      page.should have_content(offer.merchant.name)

      click_link 'Give Now'
    end
  end

  def complete_order
    page.should have_content('Complete Your Transaction')

    fill_in 'Card Number', :with => 1
    select  (Date.today.year + 1).to_s, :from => 'Expiration'
    fill_in 'CVC Code',    :with => 157

    fill_in 'First Name',     :with => 'Galen'
    fill_in 'Last Name',      :with => 'Guenther'
    fill_in 'Street Address', :with => '1750 San Jose Ave.'
    fill_in 'City',           :with => 'Alameda'
    select 'California',      :from => 'State'
    fill_in 'Postal Code',    :with => '94501'
    fill_in 'Email Address',  :with => 'galen@fake.net'

    check 'customer_terms'

    click_on 'Give Now'
  end

 
  def assert_rewards_from_offers(offers, charity)
    page.should have_content('Success')

    customers = Customer.where(:email => 'galen@fake.net')
    customers.size.should eq(1)

    customer = customers.first
    customer.orders.size.should eq(1)

    order = customer.orders.first
    order.certificates.size.should eq(offers.size)

    # You made the following charitable gift:
    page.should have_content("to #{charity.name}")

    within "#rewards" do
      # Not the best way of checking since a certificate should line up with
      # it's offer/merchant, but ...
      order.certificates.each do |certificate|
        page.should have_content(certificate.offer_value.format(:no_cents_if_whole => true))
        page.should have_content(certificate.tagline)
      end

      offers.each do |offer|
        page.should have_content(offer.merchant.name)
      end
    end
  end

  it "allows the user to buy a reward and add a donation" do
    visit charity_merchants_path(charity)
    page.should have_content("The rewards below directly support #{charity.name}")

    within "#grid" do
      page.find('.card', :text => merchant.name).click
    end

    assert_lightbox_has_offer_and_charity(offer, charity)
    assert_cart_has_offer_and_buy(offer)

    # Add a donation
    fill_in "To #{charity.name}", :with => "20"
    complete_order

    # Merchant offer + our donated $20
    donation_total = Money.new(2000) + merchant.offer.donation_value
    page.should have_content(donation_total.format)

    page.should have_content("You may deduct the following amount:")
    page.should have_content("$20.00")
  end


  describe "allows a reward to added once to the basket" do
    it "from the rewards page"
    it "from a charity's rewards page"
  end

  describe 'by reward' do
    background do 
      visit '/rewards'
      page.should have_selector('h1', :text => 'Rewards')
    end

    scenario 'allows the user to buy a reward successfully' do
      page.find(".card", :text => merchant.name).click

      # Reward charity selection
      page.should have_selector('h1', :text => "#{merchant.name} directly supports all the charities shown below")
      within "#grid" do
        page.find('.card', :text => charity.name).click
      end

      assert_lightbox_has_offer_and_charity(offer, charity)
      assert_cart_has_offer_and_buy(offer)

      complete_order

      page.should have_content(offer.donation_value.format(:no_cents_if_whole => true))
      assert_rewards_from_offers([offer], charity)
    end
  end

  describe 'by charity' do
    background do
      visit '/charities'
      page.should have_selector('h1', :text => 'Charities')
    end

    scenario 'allows the user to buy a reward successfully' do
      page.find(".card", :text => charity.name).click

      # Charity reward selection
      page.should have_content("The rewards below directly support #{charity.name}")
      within "#grid" do
        page.find('.card', :text => merchant.name).click
      end

      assert_lightbox_has_offer_and_charity(offer, charity)
      assert_cart_has_offer_and_buy(offer)

      complete_order

      page.should have_content(offer.donation_value.format(:no_cents_if_whole => true))
      assert_rewards_from_offers([offer], charity)
    end

    scenario 'includes featured merchants in the grid' do
      charity.featurings.new.tap do |f|
        f.merchant = merchant
      end.save!

      visit charity_merchants_path(charity)
      page.should have_content("The rewards below directly support #{charity.name}")

      within "#grid" do
        page.should have_selector('.card', :text => merchant.name)
      end
    end

    describe 'with bundles' do
      let!(:bundles) { create_list(:bundle_with_bundlings, 3, :charity => charity) }
      let!(:bundle)  { bundles.sample }

      scenario 'allows them to only be added to the basket once'

      scenario 'allows the user to buy a bundle' do
        page.find(".card", :text => charity.name).click

        # Charity reward selection
        page.should have_selector('h1', :text => charity.name)

        within ".card-group-bundles" do
          page.find('.card', :text => bundle.name).click
        end

        wait_until_element_exists "#lightbox" do
          page.should have_content("Here's The Deal")

          page.should have_content("when you give #{bundle.donation_value.format(:no_cents_if_whole => true)}")
          page.should have_content(charity.name)

          bundle.offers.each do |o|
            page.should have_content(o.merchant.name)
          end

          click_on 'Add all rewards to cart'
        end

        wait_until_element_exists "#cart" do 
          # Cart slides up, so we need to wait until it's done.
          wait_until { page.find('a', :text => 'Give Now').visible? }

          bundle.offers.each do |o|
            page.should have_content(o.merchant.name)
          end

          click_link 'Give Now'
        end

        complete_order
        page.should have_content(bundle.donation_value.format(:no_cents_if_whole => true))
        assert_rewards_from_offers(bundle.offers, charity)
      end
    end
  end

  scenario "allows the user to print purchased certificates" do
    customer = create(:customer_with_order)
    customer.orders.size.should eq(1)
    order = customer.orders.first
    certificate = order.certificates.first

    visit order_path(order)

    within "#rewards" do
      page.should have_content(certificate.merchant.name)
      page.should have_content(certificate.offer_value.format(:no_cents_if_whole => true))

      page.find('div.certificate-small a', :text => 'Print Certificate').click
    end

    within '.certificate-print' do
      page.should have_content(certificate.merchant.name)
      page.should have_content(certificate.offer_value.format(:no_cents_if_whole => true))
      page.should have_content(certificate.code)
    end

    page.should have_content('Join Givegoods.')
  end
end

