# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'prototype_legacy_helper'

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


 	def create_wikipage(wikipage,data,bio)
		mw = MediaWiki::Gateway.new('http://wiki.ead.pucv.cl/api.php')
		mw.login('rodrigomt', '1dvuvvdu')
		mw.create(wikipage,data)
		@remotewikipage =  MediaWiki.wiki_to_uri(wikipage)

		return @remotewikipage
	end
 	def edit_wikipage(wikipage,data)
		mw = MediaWiki::Gateway.new('http://wiki.ead.pucv.cl/api.php')
		mw.login('rodrigomt', '1dvuvvdu')
		mw.edit(MediaWiki.uri_to_wiki(wikipage),data)
		@remotewikipage =  MediaWiki.wiki_to_uri(wikipage)

		return @remotewikipage
	end	
end
