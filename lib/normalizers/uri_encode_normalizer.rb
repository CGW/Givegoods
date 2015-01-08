module Normalizers
  module UriEncodeNormalizer
    def self.normalize(value, options = nil)
      if value.present? && value.is_a?(String)
        value = URI.encode(value)
      end

      value
    end
  end
end
