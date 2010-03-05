# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_russia_session',
  :secret      => '65f75e71168ed5dbd38d32f753cd776a435a35f989444e2ee886793ac1922236f569156390c9779cba8ea8053990c7bed0ff5b83a7f633a6bb476d3d288d96c9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
