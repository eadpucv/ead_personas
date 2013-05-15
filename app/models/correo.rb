class Correo < ActionMailer::Base
  
  def mail(id,tipo)
	@tipo = tipo
	@usuario = Usuario.find(id)
	@from = "personas.ead@gmail.com"
	@recipients = @usuario.mail
	
	if tipo == "mm"
		@subject = "Actualiza tus datos en [personas e[ad]]"
	end
	if tipo == "nuevo"	
		@subject = "Bienvenido a Personas e[ad]"
	end
	if tipo == "recupera"
		@subject = "Recuperacion de datos [personas e[ad]]"
	end
	if tipo =="notificaPrimer"
		@subject = "Actualizacion de Datos [personas e[ad]]"
	end

  end

end
