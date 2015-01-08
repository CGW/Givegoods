require 'spec_helper'

describe RoleAssignment do
  before do
    subject.user = create(:user)
  end

  it_behaves_like 'ActiveModel' 

  it { should allow_mass_assignment_of(:role) }
  it { should_not allow_mass_assignment_of(:user) }

  it { should validate_presence_of(:role).with_message(/can't be blank/) }

  it "validates presence of :user" do
    subject.user = nil
    expect { subject.save }.to raise_error(ActiveModel::StrictValidationFailed, "User can't be blank")
  end

  describe "#persisted?" do
    it "returns false" do
      subject.persisted?.should eq(false)
    end
  end

  describe "#save" do
    describe "when valid" do
      before do
        subject.should_receive(:valid?).and_return(true)
        subject.should_receive(:persist!).and_return(true)
      end

      it "returns true" do
        subject.save.should be_true
      end
    end

    describe "when invalid" do
      before do
        subject.should_receive(:valid?).and_return(false)
        subject.should_receive(:persist!).never
      end

      it "returns true" do
        subject.save.should be_false
      end
    end
  end

  describe "#persist!" do
    let(:user) { mock_model(User) }
    let(:role) { 'charity' }

    before do
      subject.role = role
      subject.user = user

      user.should_receive(:role=).with(role)
      user.should_receive(:save!).and_return(true)
    end

    it "saves the role to user" do
      subject.send(:persist!).should be_true
    end
  end
end
