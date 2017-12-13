class User < ActiveRecord::Base

	validates_presence_of :usuario, :message => "Es necesario un nombre de usuario."
	validates_presence_of :mail, :message => "Es necesario una direccion de correo electronico."
	validates_presence_of :nombre, :message => "Es necesario indicar tus nombres."
	validates_presence_of :apellido, :message => "Es necesario indicar tus apellidos."
	validates_uniqueness_of :usuario, :message => "El nombre de usuario que indicaste ya existe."
	validates_uniqueness_of :mail, :message => "La direccion de correo electronico que indicaste ya existe."

	def self.authenticate(email, password)
		result = nil
		user = self.where(mail: email).first
		if user
			if user.password == Digest::SHA1.hexdigest(password)
				result = user
			else
				redirect_to root_url, :notice => "Password incorrecto!"
			end
		else
			redirect_to root_url, :notice => "Correo no existe!"
		end
		return result
	end
	
end
