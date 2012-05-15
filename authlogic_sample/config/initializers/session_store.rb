# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_authlogic_sample_session',
  :secret      => 'f4088b1f99411e992e090afbebbeb8f26d55b26e5a11ab9e313a0eae4c2405445f6e16e4a98faab0cf732911ad8a6c61945c2a268f3ed4bd090b43bdb295c105'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
