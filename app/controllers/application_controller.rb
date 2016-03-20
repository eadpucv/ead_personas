class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	# include all helpers, all the time
	helper :all
	# include prototype_legacy_helper
	# require 'prototype_legacy_helper'

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

	def generateUniqueHexCode(codeLength)
		validChars = ("A".."F").to_a + ("0".."9").to_a
		length = validChars.size
		hexCode = ""
		1.upto(codeLength) { |i| hexCode << validChars[rand(length-1)] }
		hexCode
	end


	# Metodos re-factorizados
	
	# A partir del usuario almacenado en la sesion, verifica si el asuario actual es admin.
	# Retorna true o false segun sea el caso. 
	def is_admin
		if session[:cas_user]
			if User.where(["usuario = ?", session[:cas_user]]).first.admin == "si"
				true
			else
				false
			end
		else
			false
		end
	end

	# A partir del user_id determina si el usuario es el mismo que inicio sesion.
	# Retorna true o false segun sea el caso.
	def edit_my_own_user(user_id)
		if session[:cas_user]
			if User.exists?(['usuario = ? AND id = ?',session[:cas_user], user_id])
				true
			else
				false
			end
		else
			false
		end
	end

end
