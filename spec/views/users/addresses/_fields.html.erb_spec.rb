require 'spec_helper'

describe 'users/addresses/_fields' do
  let(:template) {
    view.dup.tap do |t|
      t.extend ActionView::Helpers::FormHelper
      t.extend ActionView::Helpers::DynamicForm
    end
  }

  let(:address) { mock_model(MerchantSidekick::Addressable::Address) }
  let(:form)  { ActionView::Helpers::FormBuilder.new(:address, address, template, {}, nil) }

  it "has a form for address" do
    render :partial => 'users/addresses/fields', :locals => { :builder => form }
    rendered.should have_field('Phone')

    rendered.should have_field('Street')
    rendered.should have_field('City')
    rendered.should have_field('State')
    rendered.should have_field('Zip')

    rendered.should have_hidden_field('address[country_code]', :value => 'US')
  end
end

