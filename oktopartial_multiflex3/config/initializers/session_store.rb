# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oktopartial_multiflex3_session',
  :secret      => 'a55d93b9cb3b017bb3399a6e5906f05bddb7683579e2ca35615cd91c1cd2c53d5416c87601378c0f5cb8d6022a597f25a2f90b500477f4ad75664894597db757'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
