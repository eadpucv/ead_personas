class UserMailer < ActionMailer::Base
	default :from => "personas.ead@ead.cl"
	def registration_confirmation(user)
		@user = user
		mail(:to => user.mail, :subject => "Bienvenido a Personas e[ad]")
	end

	def recuperacion_datos(user)
		@usuario = user
		mail(:to => user.mail, :subject => "Recuperación de datos [personas e[ad]]")
	end

	def send_message(target, subject, message)
		@message = message
		mail(to: target, subject: "Mensaje EAD - [" + subject + "]")
	end

	def test_mailer(to)
		mail(:to => to, :subject => "Bleee")
	end

end
