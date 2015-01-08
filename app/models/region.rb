class Region
  extend Ambry::Model
  field :code, :name, :country_iso
  
  def to_s
    [name || code, country_iso].reject(&:blank?).join(", ")
  end
end