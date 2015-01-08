# Extends address model declared in merchant_sidekick gem
module MerchantSidekick
  module Addressable
    class Address < ActiveRecord::Base # Address.class_eval do
      validates :postal_code, :presence => true

      validates_inclusion_of :country_code,   in: Country.keys
      validates_inclusion_of :province_code,  in: Region.keys, unless: Proc.new {|a| a.province_code.blank? }

      validates :phone, :street, :city, :province_code, 
        :presence => true,
        :if => Proc.new {|a| a.addressable.is_a?(Charity) && a.addressable.active? }

      validates :street, :city, :province_code, 
        :presence => true,
        :if => Proc.new {|a| self.is_a?(BillingAddress) }

      def country
        Country.get country_code if country_code.present?
      end

      def province
        Region.get province_code if province_code.present?
      end

      alias state province
      alias state_code= province_code=
      alias state_code province_code

      alias zip_code postal_code
      alias zip_code= postal_code=
    end
  end
end
