require 'spec_helper'

describe 'users/offers/_form' do
  let(:offer) { build(:offer) }

  it "has a form a new offer" do
    render :partial => 'users/offers/form', :locals => { :offer => offer }
    rendered.should have_form(:action => user_merchant_offer_path)

    rendered.should have_field('Status')
    rendered.should have_field('Reward discount')
    rendered.should have_field('Reward value limit')
    rendered.should have_field('Maximum rewards per month')
    rendered.should have_field('Tagline')
    rendered.should have_field('Rules and conditions')

    # Support charities
    rendered.should have_checked_field('offer_charity_selection_all')
    rendered.should have_unchecked_field('offer_charity_selection_one')

    # autocomplete
    rendered.should have_hidden_field('offer[charity_id]')
    rendered.should have_field('offer[charity_name]')

    rendered.should have_button('Save reward settings')
  end
end
