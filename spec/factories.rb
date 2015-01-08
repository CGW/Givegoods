FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    first_name 'Bart'
    last_name 'Simpson'
    password "change-this"
    password_confirmation "change-this"
    confirmed_at Time.zone.now - 5.days

    trait :unconfirmed do 
      after(:create) do |u|
        u.send(:generate_confirmation_token)
        u.save!
      end
    end

    trait :charity do
      role 'charity'
    end

    trait :merchant do
      role 'merchant'
    end
  end

  factory :fbuser, :class => User do
    sequence(:email) {|n| "fbuser#{n}@example.com" }
    password "change-this"
    password_confirmation "change-this"
    first_name 'Lisa'
    last_name 'Simpson'
    facebook_uid "44827546986"
  end

  factory :merchant do
    user

    sequence(:name) {|n| "Books#{n} Inc." }
    description "The finest collection of Bob Blah Blah this world has ever seen. Books too."
    website_url "http://example.com"
    lat 37.769005
    lng -122.257233

    #offer { 
      #Offer.new({
        #:rules            => "Only one antique book per purchase.",
        #:offer_cap        => 20,
        #:discount_rate    => Offer::DISCOUNT_RATES[0],
        #:max_certificates => Offer::MAX_CERTIFICATES[0],
        #:status           => 'active'
      #})
    #}
    # picture { File.open(File.join(Rails.root, 'test', 'fixtures', 'files', 'merchants', 'booksinc-tiny.jpg')) }

    after(:create) do |merchant|
      merchant.build_address
      merchant.address.tap do |a|
        a.street        = '100 Park Street'
        a.city          = 'Alameda'
        a.province_code = 'CA'
        a.country_code  = 'US'
        a.zip_code      = '94501'
        a.phone         = '510-555-1525'
      end
      merchant.address.save!
    end
  end

  factory :offer do
    association :merchant, :factory => :merchant, :status => 'active'
    rules  "These are simple rules"
    tagline "Save on stuff and things"
    discount_rate Offer::DISCOUNT_RATES[0]
    max_certificates Offer::MAX_CERTIFICATES[0]
    offer_cap 100
    currency "USD"
    status "active"
  end

  factory :charity do
    sequence(:name)        { |n| "Charity#{n} Org."}
    sequence(:ein)         { |n| "0000000000#{n}"}
    sequence(:website_url) { |n| "http://charity#{n}.org"}
    lat 37.769005
    lng -122.257233

    after(:build) do |charity|
      charity.build_address
      charity.address.country_code  = 'US'
      charity.address.zip = '94501'
    end

    trait :picture do
      picture { File.open(File.expand_path("#{Rails.root}/test/fixtures/files/charities/save-the-redwoods.jpg", __FILE__)) }
    end

    trait :description do
      description "At Charity Org., we do our best to serve the community."
    end

    trait :email do
      sequence(:email) { |n| "contact@charity#{n}.org" }
    end

    trait :active do 
      status 'active'
    end

    trait :inactive do 
      status 'inactive'
    end

    trait :with_full_address do
      after(:build) do |charity|
        charity.address.tap do |a|
          a.phone         = '510-522-5148'
          a.street        = '2226 Buena Vista Ave.'
          a.city          = 'Alameda'
          a.province_code = 'CA'
        end
      end
    end

    factory :inactive_charity, :traits => [:inactive]
    factory :active_charity, :traits => [:active, :description, :email, :with_full_address]
  end

  # Commented until charities can have multiple campaigns; until then, the
  # CharityObserver builds a campaign for us and butts heads pretty plainly
  # with this stuff.
  #factory :campaign do
    #charity
    #tagline "Support things and stuff"
    #sequence(:slug) {|n| "books-for-kids-#{n}"}
  #end

  #factory :tier do
    #campaign
    #amount_cents 1000
  #end

  factory :deal do
    charity
    merchant { create(:offer).merchant }
    sequence(:code) {|n| Deal.new.send(:create_code)}
    amount_cents 2000
  end

  factory :bundle_deal, :class => Deal do
    charity
    bundle
    sequence(:code) {|n| Deal.new.send(:create_code)}
    amount_cents 2000
  end

  factory :customer do
    first_name "John"
    last_name "Doe"
    sequence(:email) {|n| "customer#{n}@example.com"}
    billing_address
  end

  factory :customer_with_order, parent: :customer do
    after(:create) do |customer|
      cert = create(:certificate, customer: customer)
      deal = cert.deal
      order = customer.purchase([deal], :from => deal.charity)
      order.save!
    end
  end

  factory :billing_address do
    street "Arias 1691"
    city "San Francisco"
    province_code "CA"
    country_code "US"
    postal_code "94109"
  end

  factory :certificate do
    # Deal creates most of the scaffolding, so we use it's components.
    deal
    merchant { deal.merchant }
    customer
    charity
    sequence(:code) {|n| "ABC#{n}XYZ#{n}"}
    amount_cents 4000
    offer_cap_cents 10000 
    discount_rate Certificate::DISCOUNT_RATES[0]
    rules { deal.merchant.offer.rules }
    tagline { deal.merchant.offer.tagline }
    status 'unredeemed'
  end

  factory :bundle do
    charity
    donation_value 150
    status "active"
    sequence(:name)    {|n| "A Smattering Great Stuff ##{n}"}
    sequence(:tagline) {|n| "By purchasing this collection of #{n} fine goodies, you'll be supporting #{n} diddlies we need to stay running."}
  end

  factory :bundle_with_bundlings, :parent => :bundle do
    after(:create) do |bundle|
      bundle.bundlings = create_list(:bundling, 3, :bundle => bundle)
    end
  end

  factory :bundling do
    bundle
    offer
  end

  factory :purchase_order, class: MerchantSidekick::PurchaseOrder do
  end

  factory :transaction_fee do
    amount_cents 800
  end

  factory :donation do
    charity
    amount_cents 4000
  end
end
