class CertificateActionFilter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :merchant, :filter_status, :update_status, :select_all, :selected
  
  validates_presence_of :merchant
  
  def initialize(attributes = {})
    attributes = (attributes || {}).symbolize_keys
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def certificates
    raise "No merchant assigned. Use: CertificateActionFilter.new :merchant => @merchant" unless @merchant
    @certificates = @merchant.certificates.scoped
    unless @filter_status.blank?
      @certificates = @certificates.send(@filter_status)
    end
    @certificates
  end
  
  def persisted?
    false
  end
  
  def update!
    selected_certificates.each do |certificate|
      certificate.send("#{update_status}!") if certificate.respond_to?("#{update_status}!")
    end
  end
  
  def select_all?
    !!@select_all.to_s.match(/^(1|true)/i)
  end
  
  def selected
    @selected.is_a?(Array) ? @selected.map(&:to_i) : []
  end
  
  def selected_certificates
    select_all? ? certificates.scoped : certificates.where("id IN (?)", selected).scoped
  end

  def selected?(certificate)
    selected.include?(certificate.id)
  end
  
end