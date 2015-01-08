GivegoodsSite::Application.configure do
  config.sass.line_comments = false
  config.sass.style = :expanded

  # Show line numbers in everything but production
  unless Rails.env.production?
    config.sass.line_numbers = true
  end
end



