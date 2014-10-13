# Be sure to restart your server when you modify this file.

#Buynance::Application.config.session_store :cookie_store, key: '_buynance_session'

Buynance::Application.config.session_store :active_record_store, :domain=>:all
