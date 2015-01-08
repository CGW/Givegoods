require 'spec_helper'

describe 'users/charities/_form' do
  let(:charity) { build(:charity) }

  before do
    charity.build_address
  end

  it "has a form for the charity" do
    render :partial => 'users/charities/form', :locals => { :charity => charity }
    rendered.should have_form(:action => user_charity_path, :class => 'form-horizontal')

    rendered.should have_field('Charity name')
    rendered.should have_field('EIN')
    rendered.should have_field('Website URL')
    rendered.should have_field('Zip')
    rendered.should have_hidden_field('charity[address_attributes][country_code]', :value => 'US')

    rendered.should_not have_field('Description')
    rendered.should_not have_field('Picture')

    view.should_not render_template(:partial => 'users/addresses/_fields')

    rendered.should have_button('Create charity')
  end

  describe "when charity is persisted" do
    let(:charity) { create(:charity) }
    let(:user_policy) { mock('Policy') }
    
    before do
      view.stub(:policy_alert).and_return('policy alert')
      view.stub(:user_policy).and_return(user_policy)
    end

    it 'does not have policy alerts' do
      rendered.should_not have_content('policy alert')
    end

    describe "and is inactive" do
      before do
        charity.status = 'inactive'
        charity.save 
      end

      it "has policy alerts" do
        [:basic_information, :description, :picture, :contact_information].each do |attr|
          view.stub(:policy_alert).with(user_policy, attr).and_return("policy alert for #{attr}")
        end
        render :partial => 'users/charities/form', :locals => { :charity => charity }

        [:basic_information, :description, :picture, :contact_information].each do |attr|
          rendered.should have_content("policy alert for #{attr}")
        end
      end
    end

    it "disables the name field" do
      render :partial => 'users/charities/form', :locals => { :charity => charity }
      rendered.should have_selector("span.input-large.uneditable-input", :text => charity.name)
    end

    it "shows remaining fields" do
      render :partial => 'users/charities/form', :locals => { :charity => charity }
      rendered.should have_field('Description')
      rendered.should have_field('Picture')

      rendered.should have_field('Contact email')
      view.should render_template(:partial => 'users/addresses/_fields')
    end

    it "has update button" do
      render :partial => 'users/charities/form', :locals => { :charity => charity }
      rendered.should have_button('Update charity')
    end
  end
end

