# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_http_monitor_session',
  :secret      => '6dcb4112837db9f19a61edbf2852671ea61ec96d11216b349e3f54243a789909a8da8d5661c1961d582ab653d1ca28188d74b8e9c8651315146556393dc279f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
