require 'spec_helper'

describe 'users/role_assignments/new' do
  before do
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Welcome to Givegoods')
  end

  it "has a form for charity role" do
    rendered.should have_selector('form.role_assignment_for_charity')
    rendered.should have_selector(:xpath, '//input[@name="role_assignment[role]" and @value="charity"]')
  end

  it "has a form for merchant role" do
    rendered.should have_selector('form.role_assignment_for_merchant')
    rendered.should have_selector(:xpath, '//input[@name="role_assignment[role]" and @value="merchant"]')
  end
end

