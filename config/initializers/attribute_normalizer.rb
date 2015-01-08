AttributeNormalizer.configure do |config|
  config.default_normalizers = :strip, :blank

  config.normalizers[:uri_encode] = Normalizers::UriEncodeNormalizer
end
