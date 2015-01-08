class Bundling < ActiveRecord::Base
  belongs_to :bundle
  belongs_to :offer
end
