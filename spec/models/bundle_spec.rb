require 'spec_helper'

describe Bundle do
  [:charity_id, :donation_value, :status, :name, :tagline, :notes, :image, :offer_ids,
   :address_attributes, :remote_image_url, :image_cache, :remove_image].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should belong_to(:charity) }
  it { should validate_presence_of(:charity).with_message(/can't be blank/) }

  it { should validate_presence_of(:name).with_message(/can't be blank/) }
  it { should ensure_length_of(:name).is_at_most(100).with_long_message(/is too long/) }

  it { should ensure_length_of(:tagline).is_at_most(255).with_long_message(/is too long/) }
  it { should ensure_length_of(:notes).is_at_most(255).with_long_message(/is too long/) }

  describe "#total_offer_value" do
    before do 
      offers = Array.new(3) { double('Offer', :offer_value => Money.new(20)) }
      subject.should_receive(:offers).and_return(offers)
    end
    it "should return the summed offer_values from all offers" do
      subject.total_offer_value.should eq(Money.new(60))
    end
  end
end
