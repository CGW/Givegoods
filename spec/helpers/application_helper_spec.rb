require 'spec_helper'

describe ApplicationHelper do
  describe "#render_if_present" do
    let(:value) { double('Value') }

    it "returns an empty string if the value is nil" do
      helper.render_if_present(nil) do 
        "Please don't return me"
      end.should eq("")
    end

    it "returns an empty string if the value is empty?" do
      value.stub(:empty?).and_return(true)
      helper.render_if_present(value) do 
        "I don't like being returned, it makes me angry"
      end.should eq("")
    end

    it "returns the block if the value is present" do
      value.stub(:empty?).and_return(false)
      helper.render_if_present(value) do 
        "I got returned!"
      end.should eq("I got returned!")
    end
  end

  describe "#render_unless_present" do
    let(:value) { double('Value') }

    it "returns the block if the value is nil" do
      helper.render_unless_present(nil) do
        "Please return me"
      end.should eq("Please return me")
    end

    it "returns the block if the value is empty?" do
      value.stub(:empty?).and_return(true)
      helper.render_unless_present(value) do
        "Please return me"
      end.should eq("Please return me")
    end

    it "returns an emptry string if the value is present" do
      value.stub(:empty?).and_return(false)
      helper.render_unless_present(value) do 
        "Don't return me please"
      end.should eq("")
    end
  end

end
