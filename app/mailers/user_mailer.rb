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
end
