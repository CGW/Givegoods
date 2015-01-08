require 'spec_helper'

describe 'charities/_grid_controls' do
  it "has charity search grid control" do
    render 

    rendered.should have_selector('#grid-controls', :text => "How do I give?")
    rendered.should have_xpath("//form[@action='#{search_charities_path}']")
    rendered.should have_field('Search by name')
    rendered.should have_field('Search by location')
    rendered.should have_button('Submit')
  end
end
