# Load the rails application
require File.expand_path('../application', __FILE__)
require 'casclient'
require 'casclient/frameworks/rails/filter'


CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://190.208.62.202:443/cas/")

# Initialize the rails application
Persons::Application.initialize!
