if Rails.env == "production"
  ActiveMerchant::Billing::Base.mode = :production
  MerchantSidekick::default_gateway = :authorize_net_gateway
  MerchantSidekick::default_gateway.supported_cardtypes = [:visa, :master]
=begin
  ActiveMerchant::Billing::Base.mode = :test
  MerchantSidekick::default_gateway = :bogus_gateway
=end
else
  ActiveMerchant::Billing::Base.mode = :test
  MerchantSidekick::default_gateway = :bogus_gateway
end

ActiveMerchant::Billing::CreditCard.require_verification_value = true