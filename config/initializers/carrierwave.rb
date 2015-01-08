CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJ2F4UMIAGQD6UVKA',
    :aws_secret_access_key  => 't5mFiPBvoZaYyvhiEfxlG7tKZgBOVGcTQqeLNcN+',
    :region                 => 'us-east-1'
  }
  #config.fog_directory  = ''
  #config.fog_host       = 'https://assets.example.com'          
  config.fog_public     = true                                  
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  config.storage        = :fog
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_directory = 'givegoods-org'
  end
elsif Rails.env.staging?
  CarrierWave.configure do |config|
    config.fog_directory = 'staging-givegoods-org'
  end
else
  # dev/test
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
