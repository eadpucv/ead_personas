# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'prototype_legacy_helper'

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

	def isAdmin?()
		if session[:cas_user]
			@user = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
			if @user.admin == "si"
				true
			else
				false
			end
		else
			false
		end
	end

	def editMyOwnUser?(idUsuarioEditado)
		if session[:cas_user]
			if Usuario.exists?(['usuario = ? AND id = ?',session[:cas_user], idUsuarioEditado])
				true
			else
				false
			end
		else
			false
		end
	end	

	def generateUniqueHexCode(codeLength)
		validChars = ("A".."F").to_a + ("0".."9").to_a
		length = validChars.size
		hexCode = ""
		1.upto(codeLength) { |i| hexCode << validChars[rand(length-1)] }
  	  	hexCode
	end
	
end
