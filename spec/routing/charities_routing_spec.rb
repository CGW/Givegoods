require 'spec_helper'

describe 'charities routing' do
  let(:charity) { create(:charity) }

  it 'routes /charities/:id' do
    get("/charities/#{charity.slug}").should route_to(
      :controller => 'charities',
      :action     => 'landing',
      :id         => charity.slug.to_s
    )
  end

  # Testing redirects via the should route_to idiom does not work; we have to
  # bring it back to the basics with request testing
  describe "landing redirects", :type => :request do
    it 'redirects /pages/amow-donate to amow landing' do
      get '/amow-donate'
      response.should redirect_to('/charities/alameda-meals-on-wheels-alameda-friendly-visitors')
    end

    it 'redirects /amow-donate to amow landing' do
      get '/amow-donate'
      response.should redirect_to('/charities/alameda-meals-on-wheels-alameda-friendly-visitors')
    end

    it 'redirects pages/support-faas-get-rewards to faas landing' do
      get '/pages/support-faas-get-rewards'
      response.should redirect_to('/charities/friends-of-the-alameda-animal-shelter')
    end
  end
end
