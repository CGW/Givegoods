require 'test_helper'

class FeaturingTest < ActiveSupport::TestCase
  should belong_to(:charity)
  should belong_to(:merchant)

  should "be valid" do
    assert featurings(:boys_and_girls_of_alameda_burma_superstar).valid?
  end
end
