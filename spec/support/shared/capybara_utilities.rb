
# One of those sexy self-explanatory methods
def wait_until_element_exists(element)
  wait_until { page.find(element).visible? }
  return unless block_given?
  within element do
    yield
  end
rescue Capybara::TimeoutError
  flunk "Expected '#{element}' to be present."
end
