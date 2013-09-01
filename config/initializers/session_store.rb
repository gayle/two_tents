# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
TwoTents::Application.config.session_store :cookie_store,
    :key => '_two_tents_session',
    :secret      => 'f164a8c6e2254bf0a66a27c9d59454e9d4e348eb502b1d35aada09af13a7e81177f90189774a1f9e13e74b035cb45c24b9a462acff0274c0a6791a281c972b1e'


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# TwoTents::Application.config.session_store :active_record_store
