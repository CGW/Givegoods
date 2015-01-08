shared_examples "CommonAttributes::DiscountRate is included" do
  [25, 50, 100].each do |percent|
    it { should allow_value(percent).for(:discount_rate) } 
  end

  [nil, 1, 75].each do |percent|
    it { should_not allow_value(percent).for(:discount_rate) } 
  end
end

shared_examples "CommonAttributes::OfferCapCents is included" do
  include_examples "money attribute validations", :offer_cap, 0, 1000

  describe "#any_cap?" do
    it "returns false when offer_cap_cents is not set" do
      subject.any_cap?.should be_false
    end
    it "returns false when offer_cap_cents is <= 0" do
      subject.offer_cap_cents = 0
      subject.any_cap?.should be_false
    end
    it "returns true when offer_cap_cents is set and > 0" do
      subject.offer_cap_cents = 100
      subject.any_cap?.should be_true
    end
  end

  describe '#offer_value' do
    it 'returns $0 when offer_cap_cents is not set' do
      subject.offer_value.should eq(Money.new(0))
    end

    it 'returns discounted cost' do
      subject.offer_cap_cents = 10000
      subject.discount_rate = 25

      subject.offer_value.should eq(Money.new(2500))
    end
  end
end

shared_examples "CommonAttributes::AmountCents is included" do
  include_examples "money attribute validations", :amount, 1, 500
end

shared_examples "money attribute validations" do |attr, min, max|
  it { should validate_numericality_of(:"#{attr}_cents").with_message(/is not a number/) }

  # valid values
  [min, (max / 2), max].each do |valid|
    it { should allow_value(valid * 100).for(:"#{attr}_cents") }
    # virtual, but adds errors based on "#{attr}_cents"
    it { should allow_value(valid).for(attr.to_sym) }
  end

  # invalid values are a penny different (positively/negatively depending on field)
  [(min - 0.01), (max + 0.01)].each do |invalid|
    it { should_not allow_value((invalid * 100).to_i).for(:"#{attr}_cents") }
    it { should_not allow_value(invalid).for(attr.to_sym) }
  end

  it { should_not allow_value(nil).for(:"#{attr}_cents") }

  describe "#{attr} attribute" do
    # Probably unnecessary, but currently MerchantSidekick is the gem that
    # provides this attr and it's untested. So ... 
    it "returns a Money object" do
      subject.send(attr.to_sym).should be_a(Money)
    end

    it "raises an exception when set to nil" do
      lambda { 
        subject.send("#{attr}=", nil)
      }.should raise_error(ArgumentError)
    end

    it "raises an exception when initialized to nil" do
      # Skip this test for those objects that do not make this field
      # attr_accessible
      if subject.class.accessible_attributes.include?(attr)
        lambda { 
          subject.class.new(attr => nil) 
        }.should raise_error(ArgumentError)
      end
    end
  end
end
