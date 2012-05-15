# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_okto_cms_example_session',
  :secret      => 'e17cd853a88ccc4e0762891578659ec0441cc07ac81821616bb8d21021743d7b0982ec8808373ff6d0a51787206e6501ac46157d061eeada6b47e8fa9bbea1a3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
