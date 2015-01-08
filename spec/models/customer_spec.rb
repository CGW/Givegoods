require 'spec_helper'

describe Customer do

  [:email, :first_name, :last_name, :anonymous_donation, :billing_address_attributes, :terms, :communicate_with_site].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should have_many(:certificates) }

  [:email, :first_name, :last_name].each do |attr|
    it { should validate_presence_of(attr).with_message(/Please fill in your #{attr.to_s.gsub("_", " ")}/) }
  end

  # Email is valid if matching a simple pattern:
  #   <any character>@<alphanum|->.<a-z repeated 2 or more times>
  it { should allow_value("charles+test@chuckg.org").for(:email) }
  it { should allow_value("charles12@chuckg.org").for(:email) }
  it { should_not allow_value("@nah.12o").for(:email) }

  it { should validate_acceptance_of(:terms).with_message("You must accept the terms and conditions") }

  [true, false].each do |bool|
    it { should allow_value(bool).for(:anonymous_donation) }
  end
  it { should_not allow_value(nil).for(:anonymous_donation) }
end
