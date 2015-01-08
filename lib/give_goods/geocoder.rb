# coding: utf-8
require "json"
require "rack"
require "open-uri"

module GiveGoods
  class Geocoder

    Error = Class.new(StandardError)

    attr_reader :city, :region, :lat, :lng, :ne, :sw, :query

    alias state region
    alias province region
    alias province_code region

    def initialize(query)
      @query = query
      address = Rack::Utils.escape(@query)
      uri = URI.parse "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=#{address}"
      data = uri.read
      json = JSON.parse(data)
      if json["status"] != "OK"
        raise Error, "Could not geocode address #{address}"
      else
        @lat, @lng = json["results"][0]["geometry"]["location"].values
        # TODO: don't rescue nil, provide better error handling/abstraction
        @ne = json["results"][0]["geometry"]["bounds"]["northeast"].values rescue nil
        @sw = json["results"][0]["geometry"]["bounds"]["southwest"].values rescue nil
        json["results"][0]["address_components"].each do |component|
          component["types"].each do |type|
            if type == "administrative_area_level_1"
              @region = component["short_name"]
            elsif type == "locality"
              @city = component["long_name"]
            elsif type == "administrative_area_level_2"
              @city ||= component["long_name"]
            end
          end
        end rescue nil
      end
    end

    def box
      @ne + @sw
    rescue
      # Note: here we handle the case where geocodable scope, e.g. in @charity.within, expects
      # a box geometry where the geocoder did not provide one.
      raise Error, "Could not return a box geometry"
    end

    def address
      result = []
      result << @city
      result << @region
      result.reject(&:blank?).join(", ")
    end
  end
end
