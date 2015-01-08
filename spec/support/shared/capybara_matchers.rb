#
# Helpers for asserting the state of a page.
#
# These helpers should be extensions of Capybara matchers (http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Matchers)
#
module CapybaraMatchers
  def have_image(src)
    have_xpath("//img[contains(@src,\"#{src}\")]")
  end

  def have_hidden_field(name, props={})
    have_input(name, props.merge(:type => 'hidden'))
  end

  def have_input(name, props={})
    debugger
    have_selector_with(:input, props.merge(:name => name))
  end

  def have_form(props)
    have_selector_with(:form, props)
  end

  def have_selector_with(selector, props)
    options = props.extract!(:text, :count, :visible)
    properties = props.collect {|k,v| "@#{k}='#{v}'"}
    have_xpath("//#{selector.to_s}[#{properties.join(' and ')}]", options)
  end
end
