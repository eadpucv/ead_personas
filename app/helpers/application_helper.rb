module ApplicationHelper

	def set_url_for_bar(url)
		if session[:admin] == "si"
			admin_list_url
		else
			home_user_url
		end
	end

	# retorna true en caso de que el usuario sea administrador, en el caso contrario retorna false.
	def isAdmin
		if session[:user]["usuario"]
			if User.where(["usuario = ?", session[:user]["usuario"]]).first.admin == "si"
				true
			else
				false
			end
		else
			false
		end
	end

	# retorna el tipo de usuario.
	def userKind(tag)
		kind = ""
		case tag
			when 'a'
				kind = "Alumno"
			when 'e'
				kind = "Ex-Alumno"
			when 'p'
				kind = "Profesor"
			when 'f'
				kind = "Amigo"
			when 'o'
				kind = "Otro"
		end
		# Retornamos el que corresponde o el string vacio.
		return kind
	end

end
