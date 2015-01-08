# This overloads some methods in the model provide by merchant sidekick, so make
# sure it gets loaded. Without this explicit require, it's not loaded when
# seeding the db.
require File.expand_path("../../app/models/merchant_sidekick/addressable/address", __FILE__)

# These are temporary charities loaded only for development purposes. At a later
# stage of development they will be removed.
puts "** Creating charities"
Charity.find_or_create_by_name! \
  :name        => "Save The Redwoods League",
  :ein         => '0000000000001',
  :website_url => "http://www.savetheredwoods.org",
  :description => "Save the Redwoods League protects and restores redwood forests and connects people with their peace and beauty so these wonders of the natural world flourish.",
  :lat         => 37.7913290,
  :lng         => -122.4005380,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/charities/save-the-redwoods.jpg", __FILE__)),
  :address_attributes => {
    :street       => "114 Sansome Street, Suite 1200",
    :city         => "San Francisco",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94104"
  }

Charity.find_or_create_by_name! \
  :name        => "California State Parks Foundation",
  :ein         => '0000000000002',
  :website_url => "http://www.calparks.org",
  :description => 'We help parks in California. For real.',
  :lat         => 37.7913290,
  :lng         => -122.4005380,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/charities/ca-state-parks.jpg", __FILE__)),
  :address_attributes => {
    :street       => "50 Francisco Street, Suite 110",
    :city         => "San Francisco",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94133"
  }

Charity.find_or_create_by_name! \
  :name        => "California Police Youth Foundation",
  :ein         => '0000000000003',
  :website_url => "http://www.calpyc.com",
  :description => "Helping California's youth through strong mentorship and solid values.",
  :lat         => 37.7913290,
  :lng         => -122.4005380,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/charities/ca-police-youth.png", __FILE__)),
  :address_attributes => {
    :street       => "7401 Galilee Rd. Spc. #350",
    :city         => "Roseville",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "95678"
  }

Charity.find_or_create_by_name! \
  :name        => "Alameda Food Bank",
  :ein         => '0000000000004',
  :website_url => "http://www.alamedafoodbank.org/",
  :description => "The Alameda Food bank has been helping feed Alameda's hungry for almost 30 years. Help us continue the effort by donating today.",
  :lat         => 37.77818880,
  :lng         => -122.27430850,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/charities/alameda-food-bank.jpg", __FILE__)),
  :address_attributes => {
    :street       => "1900 Thau Way",
    :city         => "Alameda",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94501"
}

Charity.find_or_create_by_name! \
  :name        => "Boys and Girls of Alameda",
  :ein         => '0000000000005',
  :website_url => "http://www.alamedabgc.org",
  :description => "Boys and Girls of Alameda has been building confidence in youth and bringing a safe environment for kids of all ages to play for 60 years.",
  :lat         => 37.77818880,
  :lng         => -122.27430850,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/charities/boys-and-girls-club.jpg", __FILE__)),
  :address_attributes => {
    :street       => "1900 3rd St",
    :city         => "Alameda",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94501"
}

puts "** Activating charities"
Charity.where(:status => 'inactive').each(&:activate!)

puts "** Creating campaigns"

Charity.find("save-the-redwoods-league").campaign.tap do |c|
  c.tagline = "Help us save the beautiful forests that have sheltered us, provided for us, and been our friends since the dawn of time."
  c.tiers.destroy_all

  c.tiers << c.tiers.build(:amount => 25, :tagline => 'Helps us water a tree for a month')
  c.tiers << c.tiers.build(:amount => 50, :tagline => 'Provide 24 hour security to one tree for 2 weeks')
  c.tiers << c.tiers.build(:amount => 100, :tagline => 'Plant a baby redwood, no seriously')
  c.tiers << c.tiers.build(:amount => 200, :tagline => 'Enables us to continue operations for a month')
end.save!

# puts "** Geocoding charities"
# Charity.all.map {|x| x.geocode; x.save!}

# These are temporary merchants loaded only for development purposes. At a later
# stage of development they will be removed.
puts "** Creating merchants and offers"
Merchant.find_or_create_by_name! "Books Inc.", {
  :description => "The West's Oldest Independent Bookseller",
  :website_url => "http://www.booksinc.net/",
  :lat         => 37.0625,
  :lng         => -122.243071,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/merchants/booksinc.png", __FILE__)),
  :address_attributes => {
    :street       => "1344 Park St",
    :city         => "Alameda",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94501"
  }
} {|m| m.status = "active"}

Offer.find_or_create_by_merchant_id! Merchant.find("books-inc").id, {
  :discount_rate    => 25,
  :max_certificates => 100,
  :offer_cap        => 20,
  :tagline          => "This is an sample tagline for Books Inc.",
  :rules            => "Not valid for educational events and classes.",
  :status           => "active"
}

Merchant.find_or_create_by_name! "Sumbody", {
  :description => "handmade. pure.",
  :website_url => "http://www.sumbody.com/",
  :lat         => 37.765541,
  :lng         => -122.243071,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/merchants/sumbody.png", __FILE__)),
  :address_attributes => {
    :street       => "1350 Park St",
    :city         => "Alameda",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94501"
  }
} {|m| m.status = "active"}

Offer.find_or_create_by_merchant_id! Merchant.find("sumbody").id, {
  :discount_rate    => 50,
  :max_certificates => 100,
  :offer_cap        => 20,
  :tagline          => "This is an sample tagline for Sumbody",
  :rules            => "Not valid for use with Spa discounts.",
  :status           => "active"
}

Merchant.find_or_create_by_name! "Burma Superstar!", {
  :description => "Indian, Chinese, Laonese, Thailandese, Burmese cuisine.",
  :website_url => "http://www.burmasuperstar.com",
  :lat         => 37.765541,
  :lng         => -122.243071,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/merchants/burma-superstar.png", __FILE__)),
  :address_attributes => {
    :street       => "4721 Telegraph Av",
    :city         => "Oakland",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94609"
  }
} {|m| m.status = "active"}

Offer.find_or_create_by_merchant_id! Merchant.find("burma-superstar").id, {
  :discount_rate    => 25,
  :max_certificates => 100,
  :offer_cap        => 40,
  :tagline          => "This is an sample tagline for Burma Superstar!",
  :rules            => "Not valid for all-you-can-eat offers.",
  :status           => "active"
}

Merchant.find_or_create_by_name! "Flowers", {
  :description => "John S Towata Flowers",
  :website_url => "na",
  :lat         => 37.765541,
  :lng         => -122.243071,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/merchants/flowers.png", __FILE__)),
  :address_attributes => {
    :street       => "2305 Santa Clara Av",
    :city         => "Oakland",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94501"
  }
} {|m| m.status = "active"}

Offer.find_or_create_by_merchant_id! Merchant.find("flowers").id, {
  :discount_rate    => 50,
  :max_certificates => 100,
  :offer_cap        => 80,
  :tagline          => "This is an sample tagline for Flowers",
  :rules            => "Not valid for roses.",
  :status           => "active"
}

Merchant.find_or_create_by_name! "Blue Dot Cafe", {
  :description => "cafe & coffee bar",
  :website_url => "http://bluedotcafeandcoffeebar.com/",
  :lat         => 37.765541,
  :lng         => -122.243071,
  :picture     => File.open(File.expand_path("../../test/fixtures/files/merchants/blue-dot-cafe.png", __FILE__)),
  :address_attributes => {
    :street       => "1910 Encinal Av",
    :city         => "Alameda",
    :state_code   => "CA",
    :country_code => "US",
    :zip_code     => "94501"
  }
} {|m| m.status = "active"}

Offer.find_or_create_by_merchant_id! Merchant.find("blue-dot-cafe").id, {
  :discount_rate    => 25,
  :max_certificates => 100,
  :offer_cap        => 100,
  :tagline          => "This is an sample tagline for Blue Dot Cafe",
  :rules            => "Not valid for Espressos.",
  :status           => "active"
}

Bundle.create!(
 :charity_id     => Charity.find('california-state-parks-foundation').id,
 :donation_value => 50.00,
 :status         => 'active',
 :name           => 'The kindling pack',
 :tagline        => "This will help our volunteer save any saplings that are in peril during the our yearly purge of the undergrowth.",
).tap do |b|
  Offer.limit(3).each do |offer|
    b.bundlings.create!(:offer => offer)
  end
end

Bundle.create!(
 :charity_id     => Charity.find('california-state-parks-foundation').id,
 :donation_value => 100.00,
 :status         => 'active',
 :name           => 'The flame kit',
 :tagline        => "Get all up in our business with the flame kit. It'll help us burn out any of the lowly plant-life on the forest floor that start the worst of forest fires. It takes hard work, we'll use your donation to help feed the ranks of people who come out to help.",
 :notes          => "Additionally, you will receive 3 flame retardent water bottles as an extra big thank you.",
).tap do |b|
  Offer.limit(5).each do |offer|
    b.bundlings.create!(:offer => offer)
  end
end

# puts "** Geocoding merchants"
# Merchant.all.map {|x| x.geocode; x.save!}

# Create a default admin user
puts "** Creating admin user"
admin_user = AdminUser.find_or_initialize_by_email 'manager@givegoods.org'
admin_user.password = admin_user.password_confirmation = 'oakland510:burma'
admin_user.save!
