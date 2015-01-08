
class CompleteAddressPolicy
  def initialize(address)
    @address = address
  end

  def complete?
    [:phone, :street, :city, :province_code, :postal_code, :country_code].all? do |attr|
      @address.send(attr).present?
    end
  end
end
