require 'test_helper'

class BundlingTest < ActiveSupport::TestCase
  should belong_to(:bundle)
  should belong_to(:offer)
end
