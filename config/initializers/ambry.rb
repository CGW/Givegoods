require "csv"
countries = Rails.root.join("db", "countries.csv")
regions   = Rails.root.join("db", "regions.csv")

CSV.foreach(countries, headers: true) {|row| Country.create(row)}
CSV.foreach(regions,   headers: true) {|row| Region.create(row)}
