require 'spec_helper'

describe "charities/_index" do
  let(:charities) { create_list(:charity, 4) }

  describe "when charities exist" do
    it "has has surrounding div with correct classes" do
      render :partial => 'charities/index', :locals => { :charities => charities }
      rendered.should have_selector('div.card-group.card-group-singles')
    end

    it "has a grid card for each charity" do
      render :partial => 'charities/index', :locals => { :charities => charities }

      charities.each do |charity|
        rendered.should have_selector("div##{dom_id(charity)}")
        rendered.should have_xpath(".//a[@href='#{charity_merchants_path(charity)}']")
        rendered.should_not have_xpath(".//div/a[@data-remote='true']")
        rendered.should have_image(charity.picture.grid)
        rendered.should have_content(charity.name)
        rendered.should have_content(charity.city_and_state)
      end
    end

    describe "merchant has been set" do
      let(:merchant) { create(:merchant) }

      it "shows a remote link to the merchant_charity_path" do
        render :partial => 'charities/index', :locals => { :charities => charities, :merchant => merchant }

        charities.each do |charity| 
          rendered.should_not have_xpath(".//a[@href='#{charity_merchants_path(charity)}']")
          rendered.should have_xpath(".//a[@href='#{merchant_charity_path(merchant, charity)}' and @data-remote='true']")
        end
      end
    end
  end

  describe "when no charities exist" do
    it "has a message when no charities exist" do
      render :partial => 'charities/index', :locals => { :charities => [] }
      rendered.should have_content("Sorry! We couldn't find any charities that matched your request.")
    end
  end

  it "renders grid/index partial" do
    render :partial => 'charities/index', :locals => { :charities => charities }

    view.should render_template(:partial => 'shared/grid/_index', :count => 1)
  end
end

