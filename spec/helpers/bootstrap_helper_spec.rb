require 'spec_helper'

describe BootstrapHelper do
  let(:form) { mock('FormObject') }
  let(:resource) { mock('Resource') }

  describe "#error_group_for" do 
    before do
      form.should_receive(:object).and_return(resource)
    end

    it "returns an empty string if form has no errors" do
      resource.should_receive(:errors).and_return([])
      helper.error_group_for(form).should eq("")
    end

    describe "with errors" do
      let(:errors)  { ["First message", "Second message", "Third message"] }

      before do
        resource.stub_chain(:errors, :empty?).and_return(false)
        resource.stub_chain(:errors, :full_messages).and_return(errors)
      end

      it "returns a ul with li elements for each error" do
        result = helper.error_group_for(form)

        errors.each do |error|
          result.should have_selector('ul li', :text => error)
        end
      end

      it "adds the error text if set" do
        result = helper.error_group_for(form) do
          "Hello"
        end

        result.should have_selector("div.alert p", :text => "Hello")
      end
    end
  end

  describe "#control_group_for" do
    let(:template) {
      Object.new.tap do |t|
        t.extend ActionView::Helpers::FormHelper
        t.extend ActionView::Helpers::DynamicForm
      end
    }
    
    let(:field) { :a_field_for_great_justice }
    let(:label) { 'Field' }
    let(:form)  { ActionView::Helpers::FormBuilder.new(:resource, resource, template, {}, nil) }

    before do
      form.stub(:error_message_on).and_return(nil)
      form.stub_chain(:object, :class, :human_attribute_name).with(field).and_return(label)
    end

    it "returns a control-group element" do
      result = helper.control_group_for(form, field) do
        "Put some form shit here son"
      end

      result.should have_selector('div.control-group div.controls', :text => "Put some form shit here son")
      result.should have_selector('div.control-group label.control-label', :text => label)
    end

    it "renders a custom label" do
      result = helper.control_group_for(form, field, :label => "Custom label") do 
        "Test"
      end
      result.should have_selector('div.control-group label.control-label', :text => "Custom label")
    end

    it "does not render a label" do
      result = helper.control_group_for(form, field, :label => nil) do 
        "Test"
      end
      result.should have_selector('label.control-label')
    end

    it "renders optional id" do
      result = helper.control_group_for(form, field, :id => 'resource_69') do 
        "Test"
      end

      result.should have_selector('div#resource_69')
    end

    it "renders optional css classes" do
      result = helper.control_group_for(form, field, :class => 'custom-class') do 
        "Test"
      end
      result.should have_selector('div.control-group.custom-class')
    end

    describe "when there are errors on the field" do
      before do
        form.should_receive(:error_message_on).with(field).and_return(['an error'])
      end

      it "adds error class to containing div" do
        result = helper.control_group_for(form, field) do
          "Put some form shit here son"
        end

        result.should have_selector('div.control-group.error')
      end
    end
  end
end
