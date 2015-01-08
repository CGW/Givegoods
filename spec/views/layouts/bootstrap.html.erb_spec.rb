require 'spec_helper'

describe 'layouts/bootstrap' do
  it "has a title" do
    render
    rendered.should have_selector('title', :text => view.page_title)
  end

  it "should have description meta" do
    render
    rendered.should have_xpath(".//meta[@content='#{I18n.t('site.meta_description')}']")
  end

  it "renders google analytics partial" do
    render
    view.should render_template(:partial => 'layouts/_google_analytics', :count => 1)
  end

  it "renders get satisfaction partial" do
    render
    view.should render_template(:partial => 'layouts/_get_satisfaction', :count => 1)
  end

  describe "when content for :javascripts is set" do
    before do
      view.content_for(:javascripts) do
        "Content for javascripts!"
      end
      render
    end
    it "renders the contents" do  
      rendered.should have_content("Content for javascripts!")
    end
  end

  describe "when content for :stylesheets is set" do
    before do
      view.content_for(:stylesheets) do
        "Content for stylesheets!"
      end
      render
    end
    it "renders the contents" do  
      rendered.should have_content("Content for stylesheets!")
    end
  end

  describe "when content for :body is set" do
    before do
      view.content_for(:body) do
        "Content for body!"
      end
      render
    end
    it "renders the contents" do  
      rendered.should have_content("Content for body!")
    end
  end
end
