# Some tasks to import the 830,000-odd charities into GiveGoods for seeding.
# After the intial launch, we can likely remove these tasks.

module CharitiesLoader
  extend self

  def tmp(file)
    Rails.root.join("tmp", File.basename(file))
  end


  def curl(url)
    user_agent  = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) " +
                  "AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 " +
                  "Safari/535.7"
    sh "curl -A '#{$user_agent}' '#{url}' -o #{tmp(url)}"
  end
end

namespace :charities do

  featured_charities  = CharitiesLoader.tmp("featured_charities.csv")
  givegoods_csv_zip   = CharitiesLoader.tmp("givegoods.csv.zip")
  charities_final_tab = CharitiesLoader.tmp("charities.final.tab")
  givegoods_csv       = CharitiesLoader.tmp("givegoods.csv")

  desc "Delete downloaded database files"
  task :clean do
    rm_f featured_charities
    rm_f givegoods_csv_zip
  end

  desc "Download the charity database files"
  task :download do
    unless File.exists? featured_charities
      CharitiesLoader.curl("http://basecampmusic.com/givegoods.org/data/featured_charities.csv")
    end
    unless File.exists? givegoods_csv_zip
      CharitiesLoader.curl("https://s3-us-west-1.amazonaws.com/gc-deliverable/givegoods.csv.zip")
    end
    unless File.exists? givegoods_csv
      sh "unzip -n -d #{Rails.root.join("tmp")} #{givegoods_csv_zip}"
    end
  end

  desc "Loads only Alameda pictures"
  task :load_alameda_pictures => :environment do
    geocoder = GiveGoods::Geocoder.new("Alameda, CA")
    scoped = Charity.within(geocoder)
    scoped = scoped.where("picture IS NULL AND temp_image_url IS NOT NULL")
    scoped = scoped.order("name ASC")
    scoped.each do |c|
      begin
        if c.picture.present?
          puts "Skipping #{c.slug}"
        end
        c = Charity.find(c)
        c.remote_picture_url = c.best_image_url
        if c.save
          puts "#{c.slug}"
        else
          puts "ERROR\t#{c.id}"
        end
      rescue CarrierWave::IntegrityError => e
        puts "ERROR\t#{c.id}\t#{e.message}"
      rescue => e
        puts "LIKE TOTALLY HUGE ERROR\t#{c.id}\t#{e.message}"
      end
    end
  end

  desc "Loads pictures"
  task :load_pictures => :environment do
    Charity.for_picture_import.find_each do |c|
      begin
        c.remote_picture_url = c.best_image_url
        if c.save
          puts "#{c.slug}"
        else
          puts "ERROR\t#{c.id}"
        end
      rescue CarrierWave::IntegrityError => e
        puts "ERROR\t#{c.id}\t#{e.message}"
      end
    end
  end

  desc "Process and merge the charity database files"
  task :preprocess => :download do
    unless File.exists? charities_final_tab
      seen = {}
      i = 0
      File.open(charities_final_tab, "w") do |outfile|
        [featured_charities, givegoods_csv].each do |file|
          File.open(file, "r") do |handle|
            handle.each_line do |line|
              ein, name, city, state, x1, country, x2, x3, website, img1, img2,
              lat, lng, metro = line.split('|').map do |x|
                x == '\N' ? nil : x.strip
              end
              next unless country == "United States"
              next if seen[ein]
              i = i.next
              seen[ein] = true
              row = [ein, name, city, state, website, img1, img2, lat, lng, metro]
              outfile.write row.join("\t") + "\n"
              puts "#{i}" if i % 10_000 == 0
            end
          end
        end
      end
    end
  end

  desc "Re-geocode the charities database."
  task :geocode => :environment do
    conn = ActiveRecord::Base.connection
    cities = conn.select_values %q{
      SELECT DISTINCT(city, province_code) AS result
      FROM addresses
      ORDER BY result ASC
    }
    cities.each do |city|
      city = city.tr('()', '').gsub('"', '')
      city_name, state = city.split(",")
      lat, lng = GiveGoods::Geocoder.geocode(city)
      if !lat || !lng
        puts "No geocoding results for #{city}"
      else
        conn.execute %Q{
          UPDATE charities set lat = #{lat}, lng = #{lng}
          WHERE id IN (
            SELECT charities.id FROM charities
            JOIN addresses ON
              addresses.addressable_type = 'Charity'
              AND addressable_id = charities.id
            WHERE addresses.city = '#{city_name}'
            AND addresses.province_code = '#{state}'
          )}
        puts "#{city} (#{lat}, #{lng})"
      end
    end
  end

  task :import => [:preprocess, :environment] do
    # require Rails.root.join("app/models/merchant_sidekick/addressable/address")
    # Charity.delete_all
    # MerchantSidekick::Addressable::Address.delete_all "addressable_type = 'Charity'"
    File.open(charities_final_tab, "r") do |file|
      file.each_line do |line|
        ein, name, city, state, website, img1, img2, lat, lng, metro = line.split("\t")
        next if Charity.where(:ein => ein).count != 0
        charity = Charity.new \
          :name            => name,
          :lat             => lat,
          :lng             => lng,
          :website_url     => website,
          :ein             => ein,
          :temp_image_url  => img1,
          :temp_image_url2 => img2,
          :metro_area_name => metro,
          :address_attributes => {
            :city          => city,
            :province_code => state,
            :country_code  => "US"
          }
        begin
          if charity.save
            puts "+ #{charity.slug}"
          else
            puts "FAIL\t" + charity.inspect
          end
        rescue => e
          puts "Error\t" + charity.inspect
          raise e
        end
      end
    end
  end
end
