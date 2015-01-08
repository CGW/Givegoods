require 'spec_helper'

describe User do

  [:first_name, :last_name, :email, :password, :password_confirmation, :terms, :remember_me].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should_not allow_mass_assignment_of(:role) }

  it { should have_one(:merchant) }
  it { should have_one(:charity) }

  [:email, :first_name, :last_name, :password, :password_confirmation].each do |attr|
    it { should normalize_attribute(attr).from('').to(nil) }
    it { should normalize_attribute(attr).from('    ').to(nil) }
  end

  [:first_name, :last_name].each do |attr|
    it { should validate_presence_of(attr).with_message(/Please fill in your/) }
    it { should ensure_length_of(attr).is_at_most(255).with_long_message(/is too long/) }
  end

  it { should validate_acceptance_of(:terms).with_message(/You must accept the terms and conditions/) }

  [nil, 'charity', 'merchant'].each do |value|
    it { should allow_value(value).for(:role) }
  end
  it { should_not allow_value('test').for(:role) }

  describe "#name" do
    before do
      subject.should_receive(:first_name).and_return('Charles')
      subject.should_receive(:last_name).and_return('Guenther')
    end

    it "returns first and last name" do
      subject.name.should eq('Charles Guenther')
    end
  end
end

