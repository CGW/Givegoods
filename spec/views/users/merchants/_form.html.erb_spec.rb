require 'spec_helper'

describe 'users/merchants/_form' do
  let(:merchant) { build(:merchant) }

  before do
    merchant.build_address
  end

  it "has a form for the merchant" do
    render :partial => 'users/merchants/form', :locals => { :merchant => merchant }
    rendered.should have_form(:action => user_merchant_path, :class => 'form-horizontal')

    rendered.should have_field('Name')
    rendered.should have_field('Website URL')
    rendered.should have_field('Zip')
    rendered.should have_hidden_field('merchant[address_attributes][country_code]', :value => 'US')

    view.should_not render_template(:partial => 'users/addresses/_fields')

    rendered.should have_button('Create merchant')
  end

  describe "when merchant is persisted" do
    let(:merchant) { create(:merchant) }
    
    before do
      render :partial => 'users/merchants/form', :locals => { :merchant => merchant }
    end

    it "disables the name field" do
      rendered.should have_selector("span.input-large.uneditable-input", :text => merchant.name)
    end

    it "shows remaining fields" do
      rendered.should have_field('Description')
      rendered.should have_field('Picture')

      view.should render_template(:partial => 'users/addresses/_fields')
    end

    it "has update button" do
      rendered.should have_button('Update merchant')
    end
  end
end


