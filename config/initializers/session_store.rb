# Be sure to restart your server when you modify this file.
domain = {domain: '.givegoods.org'}.reject {|k, v| !Rails.env.production?}

GivegoodsSite::Application.config.session_store :cookie_store, {
  key: '_givegoods_site_session',
#  secure: Rails.env.production?,
#  httponly: true, 
  expire_after: 60.minutes
}.merge(domain)

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# GivegoodsSite::Application.config.session_store :active_record_store
