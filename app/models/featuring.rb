class Featuring < ActiveRecord::Base
  belongs_to :charity
  belongs_to :merchant

  validates_presence_of :charity, :merchant
end
