class Country
  extend Ambry::Model
  field :iso_code, :name, :long_name

  alias to_s name

end