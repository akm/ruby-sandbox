# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_plugin_report_session',
  :secret      => '0bbec09a659c1a6841009dfe5ef66954062c6e65d513b3c7a4ffc52c0a71e60ea2de2314d0a2c4d5bfe71cf916750faf57269bffd13dc425282dee655938ce3b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
