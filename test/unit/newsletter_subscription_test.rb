require 'test_helper'

class NewsletterSubscriptionTest < ActiveSupport::TestCase
  should belong_to :customer
  should belong_to :charity
  should belong_to :merchant
end
