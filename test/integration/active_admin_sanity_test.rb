require 'test_helper'

class ActiveAdminSanityTest < ActionDispatch::IntegrationTest
  # Test fix for undefined method `buttons' for #<Formtastic::FormBuilder:0x007f8aaca61a38>
  # see: http://stackoverflow.com/questions/10087737/activeadmin-error-no-superclass-method-buttons
  test "formtastic active admin regression" do
    sign_in_as_admin
    get new_admin_merchant_path
    assert_response :success
  end

  test "edit charity with a null featured merchant" do
    sign_in_as_admin
    charity = charities(:boys_and_girls_of_alameda)
    charity.featurings.build(:merchant_id => 999).save :validate => false
    get edit_admin_charity_path(charity)
    assert_response :success
  end
end
