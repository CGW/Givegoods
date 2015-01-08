module GiveGoods
  module Geocodable
    def self.included(model_class)
      model_class.extend ClassMethods
      model_class.before_save :geocode_change
    end

    def geocode
      geocoder = ::GiveGoods::Geocoder.new(address.to_s)
      self.lat = geocoder.lat
      self.lng = geocoder.lng
    rescue => e
      self.lat = nil
      self.lng = nil
      Rails.logger.error e.backtrace
    end

    def geocode_change
      geocode if respond_to?(:address) && address && address.changed? && !(changes[:lat] || changes[:lng])
    end

    module ClassMethods

      # Accepts an array like [lat, lng], or an object which responds to both
      # +lat+ and +lng+ methods. Also accepts an optional radius in meters which
      # defaults to 20 km.
      #
      # If lat_lng is an instance of the model class, then the scope will also
      # exclude the given instance by id, i.e., records are not "near
      # themselves."
      #
      # Returns a scope, ordered by distance from the latitude and longitude of
      # the argument passed.
      def near(lat_lng, radius = 16000)
        lat    = connection.quote(lat_lng.respond_to?(:lat) ? lat_lng.try(:lat) : lat_lng[0])
        lng    = connection.quote(lat_lng.respond_to?(:lng) ? lat_lng.try(:lng) : lat_lng[1])
        radius = connection.quote(radius)
        scope = where("earth_box(ll_to_earth(#{lat}, #{lng}), #{radius}) @> ll_to_earth(#{quoted_table_name}.lat, #{quoted_table_name}.lng)")
        scope = scope.where("#{quoted_table_name}.id <> ?", lat_lng.id) if lat_lng.kind_of? self
        scope.sorted_by_distance(lat, lng)
      end

      def sorted_by_distance(lat, lng)
        order("point(#{lat}, #{lng}) <@> point(#{quoted_table_name}.lng, #{quoted_table_name}.lat) DESC")
      end

      # Get the closest records, using the best precision available. If the
      # argument can supply a valid box, then use that. Otherwise, fall back to
      # latitude and longitude.
      def close_to(geo)
        if box = geo.try(:box) rescue nil
          within(geo)
        else
          near(geo)
        end
      end

      # Sort results that are an exact match for the city and province code
      # first. Note that AR/Arel are sensitive to the order in which the scopes
      # are invoked; make sure you invoke this scope BEFORE any other scope
      # which adds a location-sensitive ordering, or else it may not give the
      # intended results.
      def preferring(city, province_code)
        includes(:address).order("(addresses.city = '#{city}' AND addresses.province_code = '#{province_code}') DESC")
      end

      # Searches for records whose latitude and longitude fall inside the box
      # delimited by the arguments. This box information is obtained from
      # Google's geocoder.
      def bounded_by(lat1, lng1, lat2, lng2)
        arg_string = [lat1, lng1, lat2, lng2].map {|x| connection.quote(x)}.join(", ")
        scope = where("city_bounds(#{arg_string}) @> ll_to_earth(#{quoted_table_name}.lat, #{quoted_table_name}.lng)")
        scope.order("(city_center(#{arg_string}) <@> point(#{quoted_table_name}.lat, #{quoted_table_name}.lng)) ASC")
      end

      def within(geocoder)
        preferring(geocoder.city, geocoder.state).bounded_by(*geocoder.box)
      end
    end
  end
end
