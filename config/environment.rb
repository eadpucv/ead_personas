# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Enlaza la aplicacion con el servidor CAS
require 'casclient'
require 'casclient/frameworks/rails/filter'
# CASClient::Frameworks::Rails::Filter.configure(:cas_base_url => "https://cas.ead.pucv.cl")
CASClient::Frameworks::Rails::Filter.configure(:cas_base_url => "http://localhost:4000/cas")

# Initialize the Rails application.
Rails.application.initialize!
