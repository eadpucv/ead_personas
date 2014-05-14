class UserController < ApplicationController
before_filter CASClient::Frameworks::Rails::Filter, :except => [ :signup, :editPublico, :update, :create, :checkUser, :checkMail, :enviaRecuperaMail, :recuperacionDatos]
require 'media_wiki'

###########
# USUARIO

	def signup
		@usuario = Usuario.new
	end

	def editPublico
		@id = params[:id]
		@t = params[:t]
		@usuario = Usuario.find(:first, :conditions => ["id = ? AND token = ?",@id,@t])

		if @usuario.nil?
			redirect_to  root_path
		end
	end

	def edit
		if isAdmin? || editMyOwnUser?(params[:id])
			@usuario = Usuario.find(params[:id])
		else
			redirect_to  root_path
		end
	end

	def update
		@usuario = Usuario.find(params[:id])
		if isAdmin? || params[:t] == @usuario.token || editMyOwnUser?(params[:id])
			if params[:usuario][:password]
				if params[:usuario][:password] == params[:contrasena_rep]
					@usuario.password = Digest::SHA1.hexdigest("#{params[:usuario][:password]}")
					@usuario.save!
					flash[:notice] = "Contraseña Actualizada"		
				else
					flash[:notice] = "Las contraseñas no coinciden"		
				end
			else
				@usuario.update_attributes(params[:usuario])
				flash[:notice] = "Los datos se han actualizado correctamente."		
			end
		end
		redirect_to  root_path
	end

	def create
		@usuario = Usuario.new(params[:usuario])
		@mail = params[:usuario][:mail]
		@username = params[:usuario][:usuario]
		@wikipage = "#{params[:usuario][:nombre]} #{params[:usuario][:apellido]}"

		@capt = params[:capt]
		@flag = 0	
		@capt_cookie = cookies[:capt]

		
		if verify_recaptcha == true
			if Usuario.exists?(:usuario=>@username) 
				flash[:notice] = "El usuario #{@username} ya existe!!"
				@flag=1
				if Usuario.exists?(:mail=>@mail)
					flash[:notice] = "El email #{@mail} ya existe!!"
					@flag=1
					if @usuario.apellido.blank?
						flash[:notice] = "El campo Apellido esta vacio"
						@flag=1
					end	
				end
			end 

			if (@flag==0)
				if @usuario.save
	  			   @contrasena = Digest::SHA1.hexdigest("#{@usuario.password}")
					@usuario.password = @contrasena
					@usuario.token = generateUniqueHexCode(10)
					@usuario.save

					if @usuario.wikipage.blank? || @usuario.wikipage == "" || @usuario.wikipage.nil?
						@wikipage = "#{params[:usuario][:nombre]} #{params[:usuario][:apellido]}"
					else
						@wikipage = @usuario.wikipage
					end

					begin
						if @usuario.tipo == "a"
							@tipo = "|Relación con la Escuela=Alumno  \n"
						elsif @usuario.tipo == "p"
							@tipo = "|Relación con la Escuela=Profesor  \n"
						elsif @usuario.tipo == "e"							
							@tipo = "|Relación con la Escuela=Ex-Alumno  \n"
						elsif @usuario.tipo == "f"
							@tipo = "|Relación con la Escuela=Amigo  \n"
						elsif @usuario.tipo == "o"
							@tipo = "|Relación con la Escuela=Otro  \n"
						end

						unless @usuario.carrera.blank?
							@carrera = "|Carreras Relacionadas=#{@usuario.carrera.capitalize} \n"
						end
						@data = "{{Persona
							|Nombre=#{@usuario.nombre}
							|Apellido=#{@usuario.apellido}
							#{@tipo}
							#{@carrera}
							}}"
						casiopea_page = create_wikipage(@wikipage,@data,params[:usuario][:bio])
						@usuario.wikipage = "http://wiki.ead.pucv.cl/index.php?title="+casiopea_page.to_s
						@usuario.save!

					rescue MediaWiki::APIError
						flash[:notice] = "La pagina de la wiki ya existe < #{@wikipage} >, Tu cuenta se creo de igual manera, pero debes actualizar tus datos"		
					end

					UserMailer.registration_confirmation(@usuario).deliver
					flash[:notice] = "Usuario Creado"
					redirect_to root_path
				else
					flash[:notice] = "No se ha podido crear el usuario | revise los campos en rojo"
					redirect_to :action => 'signup'
				end
			else
				redirect_to :action => 'signup'
			end
		else
			flash[:notice] = "El Captcha no coincide"
  		  redirect_to :action => 'signup'
		end
	end

############
# CHECKS

	def checkUser
		@usuario = Usuario.find(:all, :conditions => ["usuario = ? ", params[:user]])
		if @usuario.blank?
			@notificacion = '<span class="label label-success">disponible</span>'
		else
			@notificacion = '<span class="label label-important">no disponible</span>'
		end
		render(:text => @notificacion)
	end

	def checkMail
		@usuario = Usuario.find(:all, :conditions => ["mail = ? ", params[:mail]])
		if @usuario.blank?
			@notificacion = '<span class="label label-success">disponible</span>'
		else
			@notificacion = '<span class="label label-important">no disponible</span>'
		end
		render(:text => @notificacion)
	end

#############
# Recupera Correo

	def enviaRecuperaMail
		@tipo ="recupera"
		@usuario = Usuario.find(:first, :conditions => ["mail = ?", params[:mail]])
		if @usuario.nil?
			flash[:notice] = "Este correo no figura en nuestro registro. Tal vez te registraste con un correo antiguo que ya no usas."
			redirect_to :action => 'recuperacionDatos'
		else
			UserMailer.recuperacion_datos(@usuario).deliver
			flash[:notice] = "Los datos del usuario #{@usuario.nombre}  #{@usuario.apellido} [#{@usuario.usuario}] han sido enviados a la direccion de mail."
			redirect_to root_path
		end
	end

	def recuperacionDatos

	end

end
