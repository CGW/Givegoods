# These should all be *PRODUCTION* ids for these fields
if Rails.env.production?
  CHARITY_ID  = 10483 
else
  CHARITY_ID  = 1

end

purchasers = [
  {:email => 'charles@chuckg.org', :merchant_id => 8},
  {:email => 'jim@givegoods.org', :merchant_id => 45},
  #{:email => "cbianchi@hbrinfo.com", :merchant_id => 8},
  #{:email => "mjfboo@aol.com", :merchant_id => 8},
  #{:email => "cmbianchi@comcast.net", :merchant_id => 8},
  #{:email => "wafflessit@gmail.com", :merchant_id => 8},
  #{:email => "stacey-goffjohnson@comcast.net", :merchant_id => 8},
  #{:email => "wlp1272@yahoo.com", :merchant_id => 8},
  #{:email => "wlp1272@yahoo.com", :merchant_id => 8},
  #{:email => "patricia.a.finnegan@gmail.com", :merchant_id => 8},
  #{:email => "jadetree246@gmail.com", :merchant_id => 8},
  #{:email => "pruitt112@gmail.com", :merchant_id => 8},
  #{:email => "nicola.broderick@gmail.com", :merchant_id => 8},
  #{:email => "chappie10@sbcglobal.net", :merchant_id => 8},
  #{:email => "christanicholas@yahoo.com", :merchant_id => 8},
  #{:email => "catrost1@gmail.com", :merchant_id => 8},
  #{:email => "shelleybobelly@yahoo.com", :merchant_id => 8},
  #{:email => "guimetkeeney@gmail.com", :merchant_id => 8},
  #{:email => "Cathy.Sherrer@kp.org", :merchant_id => 8},
  #{:email => "cheshire49@yahoo.com", :merchant_id => 13},
  #{:email => "unomarin@gmail.com", :merchant_id => 60},
  #{:email => "jasondberger@gmail.com", :merchant_id => 60},
  #{:email => "christinefry@ymail.com", :merchant_id => 60},
  #{:email => "epokpo@comcast.net", :merchant_id => 60},
  #{:email => "shelly@shellygable.com", :merchant_id => 60},
  #{:email => "kkenney@girlsincislandcity.org", :merchant_id => 60},
  #{:email => "lee.hickman@paradigmcorp.com", :merchant_id => 60},
  #{:email => "mebhowe@gmail.com", :merchant_id => 60},
  #{:email => "jenjwu@gmail.com", :merchant_id => 60},
  #{:email => "carla.thornton@mindspring.com", :merchant_id => 45},
  #{:email => "charliedog2004@comcast.net", :merchant_id => 45},
  #{:email => "GAILAHMET@HOTMAIL.COM", :merchant_id => 45},
  #{:email => "Marcklein@me.com", :merchant_id => 45},
  #{:email => "Marcklein@me.com", :merchant_id => 45},
  #{:email => "CKelWhit@aol.com", :merchant_id => 65},
  #{:email => "ppf24@comcast.net", :merchant_id => 65},
  #{:email => "ruth@mannersforlife.com", :merchant_id => 65},
  #{:email => "jbonachea@sbcglobal.net", :merchant_id => 59},
  #{:email => "qvaughan@yahoo.com", :merchant_id => 59},
  #{:email => "shelliebebe@yahoo.com", :merchant_id => 59},
  #{:email => "justinlibay@yahoo.com", :merchant_id => 59},
  #{:email => "nikki_peralta@yahoo.com", :merchant_id => 59},
  #{:email => "lornasteele@comcast.net", :merchant_id => 59},
  #{:email => "janetleebutler@hotmail.com", :merchant_id => 59},
  #{:email => "michrowe@gmail.com", :merchant_id => 59},
  #{:email => "lesliewalsh47@comcast.net", :merchant_id => 51},
  #{:email => "mboudreau@alamedafs.org", :merchant_id => 51},
  #{:email => "kylekawa@gmail.com", :merchant_id => 51},
  #{:email => "carolyn.mason1@gmail.com", :merchant_id => 51},
  #{:email => "myl8898@yahoo.com", :merchant_id => 51},
  #{:email => "mom@weiss.com", :merchant_id => 51},
  #{:email => "eloise.hill@rocketmail.com", :merchant_id => 51},
  #{:email => "reessears@msn.com", :merchant_id => 51},
  #{:email => "newlin10@comcast.net", :merchant_id => 51},
  #{:email => "Kellimartin@ymail.com", :merchant_id => 51},
  #{:email => "1golfbird@comcast.net", :merchant_id => 51},
  #{:email => "cachacon@comcast.net", :merchant_id => 51},
  #{:email => "kellimartin@ymail.com", :merchant_id => 51},
  #{:email => "nthresher2@yahoo.com", :merchant_id => 51},
  #{:email => "wex0620@yahoo.com", :merchant_id => 51},
  #{:email => "susan3020@comcast.net", :merchant_id => 51},
  #{:email => "amiller.faas@gmail.com", :merchant_id => 51},
  #{:email => "gailahmet@hotmail.com", :merchant_id => 51},
  #{:email => "ski_monkey@hotmail.com", :merchant_id => 51},
  #{:email => "elenib1@yahoo.com", :merchant_id => 51},
  #{:email => "angelina0215@yahoo.com", :merchant_id => 51},
  #{:email => "angelina0215@yahoo.com", :merchant_id => 51},
  #{:email => "dragon_448@yahoo.com", :merchant_id => 51},
  #{:email => "Ophelia.garcia@sf.frb.org", :merchant_id => 51},
  #{:email => "suevee1010@msn.com", :merchant_id => 51},
  #{:email => "msmdvm@yahoo.com", :merchant_id => 51},
  #{:email => "eloise.hill@rocketmail.com", :merchant_id => 51},
  #{:email => "nomogm@juno.com", :merchant_id => 51},
  #{:email => "Marcklein@me.com", :merchant_id => 51},
  #{:email => "saldrich5@gmail.com", :merchant_id => 54},
  #{:email => "Mickey.neill@yahoo.com", :merchant_id => 74},
  #{:email => "cariturley@gmail.com", :merchant_id => 74},
  #{:email => "askisadora@aol.com", :merchant_id => 74},
  #{:email => "swonghere@gmail.com", :merchant_id => 74},
  #{:email => "CindyHeartsBirds@gmail.com", :merchant_id => 74},
  #{:email => "Stacyestokes@gmail.com", :merchant_id => 74},
  #{:email => "Andrew.stokes@hotmail.com", :merchant_id => 74},
  #{:email => "sherryperry09@comcast.net", :merchant_id => 74},
  #{:email => "lmk35@hotmail.com", :merchant_id => 74},
  #{:email => "rosaliewisecup@hotmail.com", :merchant_id => 57},
  #{:email => "kfrasch@berkeley.edu", :merchant_id => 49},
  #{:email => "paws_paws510@yahoo.com", :merchant_id => 11},
  #{:email => "rlcweber@comcast.net", :merchant_id => 53},
  #{:email => "givegoodstest", :merchant_id => 46},
  #{:email => "mimcarlson@comcast.net", :merchant_id => 46},
  #{:email => "cblyeth@yahoo.com", :merchant_id => 46},
  #{:email => "plroy@yahoo.com", :merchant_id => 46},
  #{:email => "jacqueline@autobodyfineart.com", :merchant_id => 46},
  #{:email => "boone2@pacbell.net", :merchant_id => 46},
  #{:email => "mshandobil@hbrinfo.com", :merchant_id => 46},
  #{:email => "joyceleighton@comcast.net", :merchant_id => 46},
  #{:email => "dkwestwood2@gmail.com", :merchant_id => 46},
  #{:email => "cfmurphy99@gmail.com", :merchant_id => 46},
  #{:email => "jjkel9@yahoo.com", :merchant_id => 46},
  #{:email => "Christykotowski@gmail.com", :merchant_id => 46},
]

# --------------
# Do not edit below the line

charity  = Charity.find_by_id(CHARITY_ID)

if charity.nil? 
  puts "Invalid charity id"
  exit 0
end

successful_certificates = []

Certificate.transaction do
  begin
    puts "Creating certificates for #{purchasers.count} email addresses."
    puts

    purchasers.each do |purchaser|
      customer_email = purchaser[:email]
      customer_email = "#{customer_email}.fake" unless Rails.env.production?

      merchant = Merchant.find(purchaser[:merchant_id])
      offer = merchant.offer

      customer = Customer.create!(
        :first_name => 'Givegoods',
        :last_name  => 'Promotions',
        :email      => customer_email
      )

      print "Creating certificate for #{customer.email} "

      certificate = Certificate.new do |c|
        c.charity_id  = charity.id
        c.merchant_id = merchant.id
        c.customer_id = customer.id

        # offer details
        c.tagline = offer.tagline
        c.offer_cap_cents = offer.offer_cap_cents
        c.discount_rate = offer.discount_rate

        c.amount_cents = (c.offer_cap_cents.to_f * (c.discount_rate.to_f / 100))
      end

      print "in the amount of #{certificate.amount_cents} cents ..."

      certificate.save!
      puts "done"

      successful_certificates.push(certificate)
    end
  rescue ActiveRecord::RecordInvalid => e
    puts 
    puts "Failed to create stuff ... Error: " 
    puts "\t#{e}"
    puts "Rolling back #{successful_certificates.count} certificates."

    successful_certificates = []

    raise ActiveRecord::Rollback
  rescue ActiveRecord::RecordNotFound => e
    puts 
    puts "Failed to find merchant. Error:"
    puts "\t#{e}"
    puts "Rolling back #{successful_certificates.count} certificates."

    successful_certificates = []

    raise ActiveRecord::Rollback
  end
end

puts
puts "Done creating certificates."

puts
puts "Sending emails ..."

successful_certificates.each do |c|
  puts "\t#{c.customer.email}"
  FreeOfferMailer.certificate(c).deliver
end

puts
puts "Done sending emails."

puts
puts "Finished free offers."
