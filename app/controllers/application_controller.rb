class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	# include all helpers, all the time
	helper :all
	helper_method :current_user

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

	# A partir del nombre y los metadatos creamos una pagina para la cuenta en la wiki.
	# Retorna la url de la wiki.
	def create_wikipage(wikipage_name, meta_data)
		# Incializa el gateway al api de la wiki.
		mw = MediaWiki::Gateway.new('http://wiki.ead.pucv.cl/api.php')
		# Autenticamos el acceso a la wiki.
		mw.login('rodrigomt', '1dvuvvdu')
		# Creamos la wiki acorde a los parametros proporcionados.
		mw.create(wikipage_name, meta_data)
		# Obtengo la URL de la wiki a partir del nombre con el que la cree.
		remotewikipage =  MediaWiki.wiki_to_uri(wikipage_name)
		return remotewikipage
	end

	# A partir del nombre obtengo los datos de una pagina de la wiki.
	# Retorna un objeto con los datos de la pagina en la wiki.
	def get_wikipage(wikipage_name)
		# Incializa el gateway al api de la wiki.
		mw = MediaWiki::Gateway.new('http://wiki.ead.pucv.cl/api.php')
		# Autenticamos el acceso a la wiki.
		mw.login('rodrigomt', '1dvuvvdu')
		# Verifico el formato de wikipage_name
		if wikipage_name.include? "http://wiki.ead.pucv.cl/index.php/"
			# Limpiamos el string con la url del perfil para obtener el titulo.
			wikipage_name.slice! "http://wiki.ead.pucv.cl/index.php/"
			# Obtenemos los datos de la wiki acorde a los parametros proporcionados.
			data = mw.render(wikipage_name)
		else
			data = ""
		end
		return data
	end

	# A partir del nombre y los metadatos edito una pagina en la wiki.
	# Retorna la url de la wiki.
	def edit_wikipage(wikipage_name, meta_data)
		# Incializa el gateway al api de la wiki.
		mw = MediaWiki::Gateway.new('http://wiki.ead.pucv.cl/api.php')
		# Autenticamos el acceso a la wiki.
		mw.login('rodrigomt', '1dvuvvdu')
		# Editamos la wiki acorde a los parametros proporcionados.
		mw.edit(MediaWiki.uri_to_wiki(wikipage_name), meta_data)
		# Obtengo la URL de la wiki a partir del nombre con el que la edite.
		remotewikipage =  MediaWiki.wiki_to_uri(wikipage)
		return remotewikipage
	end

	def generateUniqueHexCode(codeLength)
		validChars = ("A".."F").to_a + ("0".."9").to_a
		length = validChars.size
		hexCode = ""
		1.upto(codeLength) { |i| hexCode << validChars[rand(length-1)] }
		hexCode
	end

	def check_user
		puts "kaosbite"
		puts session[:user].inspect
		@current_user ||= User.find(session[:user]["id"]) if session[:user]
		if @current_user.nil?
			render "session/new"
		end
	end

	private
	def current_user
		@current_user ||= User.find(session[:user]["id"]) if session[:user]
	end

end
