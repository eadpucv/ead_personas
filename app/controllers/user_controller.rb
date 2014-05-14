class UserController < ApplicationController
before_filter CASClient::Frameworks::Rails::Filter
require 'media_wiki'

###########
# USUARIO

	def show
		@usuario = Usuario.find(params[:id])	
	end

	def signup
		@usuario = Usuario.new
		@captcha = generateUniqueHexCode(6)
		cookies[:capt] = @captcha
	end

	def editPublico
		@id = params[:id]
		@t = params[:t]
		@usuario = Usuario.find(:first, :conditions => ["id = ? AND token = ?",@id,@t])
	end

	def edit
		@id = params[:id]
		@usuario = Usuario.find(params[:id])

		# hago la consulta solo para comparar usuario logeado vs usuario a editar
		@loged = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
	end

	def update
		@t = params[:t]
		if Usuario.exists?(['usuario = ? AND admin= ?',session[:cas_user], 'si'])  || @t != nil || verificaUsuario(params[:id]) == TRUE
			@usuario = Usuario.find(params[:id])
			if @usuario.update_attributes(params[:usuario])
				if params[:usuario][:password]
  			        @contrasena = Digest::SHA1.hexdigest("#{@usuario.password}")
					@usuario.password = @contrasena
					@usuario.save!
				end
				flash[:notice] = "Se han actualizado los datos de <strong>#{@usuario.nombre}</strong> correctamente"
					if @usuario.tipo == "a"
						@tipo = "|Relación con la Escuela=Alumno  \n"
					end
					unless @usuario.carrera.blank?
						@carrera = "|Carreras Relacionadas=#{@usuario.carrera.capitalize} \n"
					end
				if @t != nil
					redirect_to :action => 'notificaPrimerUpdate', :id =>params[:id]
				else
					redirect_to :action => 'notificaPrimerUpdate', :id =>params[:id]
				end

					
			else
				redirect_to :action => 'edit', :id =>params[:id]    
			end
		end
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
						@wikipage = "#{params[:usuario][:nombre]}#{params[:usuario][:apellido]}"
					else
						@wikipage = @usuario.wikipage
					end

					begin
						if @usuario.tipo == "a"
							@tipo = "|Relación con la Escuela=Alumno  \n"
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
						@usuario.wikipage = create_wikipage(@wikipage,@data,params[:usuario][:bio])
						@usuario.save!
					rescue MediaWiki::APIError
						flash[:notice] = "La pagina de la wiki ya existe < #{@wikipage} >, actualiza tus datos"		
					end
					
					redirect_to :action => 'email_send', :id => @usuario.id
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

	def confirmacion	    
		render :layout => 'publico'	
	end

	def destroy
		@usuario = Usuario.find(params[:id])
		@usuario.destroy
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
			@notificacion = "Ok!"
		else
			@notificacion = "Ocupado!"
		end
		render(:text => @notificacion)
	end


	##################################################################################################################
	# acerca : Info del sitio
	###
	    def acerca

	    end


end
