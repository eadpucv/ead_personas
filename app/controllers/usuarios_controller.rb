class UsuariosController < ApplicationController
before_filter CASClient::Frameworks::Rails::Filter, :except => [:encriptar,:recuperacionDatos, :notificaPrimerUpdate, :acerca, :enviaRecuperaMail, :logout,:update,:checkMail, :checkUser, :signup, :index, :email_send, :create, :editPublico]
require 'media_wiki'

	##################################################################################################################
	# index : Index de usuario 
	###  
	def index

	end

	def email_send
		@tipo ="nuevo"
		@usuario = Usuario.find(params[:id])
		UserMailer.registration_confirmation(@usuario).deliver
		
		flash[:notice] = "El usuario #{@usuario.nombre}  #{@usuario.apellido} [#{@usuario.usuario}] se ha creado existosamente, Un mail ha sido enviado a la cuenta del usuario con los datos de tu cuenta Para modificar tus datos ingresa al login"
		redirect_to :action => 'index'
	end

	def enviaRecuperaMail
		@tipo ="recupera"
		@usuario = Usuario.find(:first, :conditions => ["mail = ?", params[:mail]])
		if @usuario.nil?
			flash[:notice] = "Este correo no figura en nuestro registro. Tal vez te registraste con un correo antiguo que ya no usas."
			redirect_to :action => 'recuperacionDatos'
		else
			UserMailer.recuperacion_datos(@usuario).deliver
			flash[:notice] = "Los datos del usuario <b>#{@usuario.nombre}  #{@usuario.apellido} [#{@usuario.usuario}] </b> han sido enviados a la direccion de mail."
			redirect_to :action => 'index'
		end
	end

	def notificaPrimerUpdate
		@tipo ="notificaPrimerUpdate"
		@usuario = Usuario.find(params[:id])
		UserMailer.update_primer(@usuario).deliver
		
		flash[:notice] = "Gracias por actualizar tus datos <b>#{@usuario.nombre}  #{@usuario.apellido} [#{@usuario.usuario}] </b> Una notificacion ha sido enviada."
		redirect_to :action => 'index'
	end

	def notificaActualizacionDatos
		@tipo ="notificaActualizacion"
		@usuario = Usuario.find(params[:id])
		flash[:notice] = "Gracias por actualizar tus datos <b>#{@usuario.nombre}  #{@usuario.apellido} [#{@usuario.usuario}] </b> Una notificacion ha sido enviada."
		redirect_to :action => 'index'
	end

	def recuperacionDatos

	end


	##################################################################################################################
	# mailList : En base a ciertos filtros, se genera una lista de correo.
	###
	def maillist
		@loged = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
	end

	##################################################################################################################
	# mailList : En base a ciertos filtros, se genera una lista de correo.
	###
	def maillistgenerator
		@tipo 		= params[:tipo]
		@carrera 	= params[:carrera]
		@anodesde 	= params[:date][:anodesde]
		@anohasta 	= params[:date][:anohasta]
		@tipoLista		=params[:tipolista]
		@it		= 1

		if @anodesde.to_i > @anohasta.to_i
			@mails = "<b>Error, Mal formato en rango de años</b>"
		else
			@sql = "SELECT usuarios.usuario, usuarios.carrera, usuarios.anoingreso,usuarios.nombre,usuarios.apellido,usuarios.mail FROM usuarios WHERE usuarios.anoingreso <= #{@anohasta} AND usuarios.anoingreso >= #{@anodesde} "
		
			if @tipo != nil
				@sql << " AND ("
				for t in @tipo
					if @it.to_i < @tipo.size.to_i
						@sql << " usuarios.tipo = '#{t}' OR"				
					else
						@sql << " usuarios.tipo = '#{t}'"				
					end
					@it = @it + 1 
				end
				@sql << ")"
			end
			@it = 1
			if @carrera != nil
				@sql << "AND ("	
				for c in @carrera
					if @it.to_i < @carrera.size.to_i 
						@sql << " usuarios.carrera LIKE '%#{c}%' OR"
					else
						@sql << " usuarios.carrera LIKE '%#{c}%'"
					end
					@it = @it + 1
				end
				@sql << ")"
			end

			@usuarios = Usuario.find_by_sql(@sql)
			@total = @usuarios.size

			@mails ="<b>#{@total}</b> usuarios encontrados <br /><br /><div id='lc_oficial'>"
			
			
			if params[:tipolista]=="correo"
				puts "entro a correo po"
				for u in @usuarios
					@mails << "<b>\"#{u.nombre} #{u.apellido}\"</b>&lt;#{u.mail}&gt;,"
				end
			elsif params[:tipolista]=="sm"
				for u in @usuarios
					@mails << "#{u.mail},#{u.nombre},#{u.apellido},#{u.carrera},#{u.anoingreso}<br/>"
				end

			end			
			@mails << "</div>"
		end
		render(:text => @mails)
	end

	##################################################################################################################
	# show : solicita y visualiza informacion de usuario 
	###
	def show
		@usuario = Usuario.find(params[:id])	
		#@listaSitios = @usuario.sitios
	end



	##################################################################################################################
	# blockedUsers : genera listado de usuarios bloqueados
	###
	def blockedUsers
		@usuarios = Usuariosbloqueados.find(:all)
	end

	##################################################################################################################
	# blockXlote : bloquear bobos por lote..
	###	
	def blockXlote
		@ids = params[:por_lote]
		@notificacion = ""
		for id in @ids
			@sql = "INSERT INTO usuariosbloqueados( id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio )
			  SELECT id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio FROM usuarios WHERE id =#{id}"
	
		    ActiveRecord::Base.establish_connection
			ActiveRecord::Base.connection.execute(@sql)
			@usuario = Usuario.find(id)
			@usuario.destroy
			@notificacion << "<script>setTimeout(\"new Effect.Fade('u_#{id}');\", 500)</script>"
		end
		render(:text => @notificacion)
	end

	##################################################################################################################
	# blockXlote : bloquear bobos por lote..
	###	
	def deleteXlote
		@ids 	= params[:por_lote]
		@option = params[:o]
		@notificacion = ""

		puts "Entro.."
		if @option == "all"
			@sql = "TRUNCATE TABLE usuariosbloqueados"
		    	ActiveRecord::Base.establish_connection
			ActiveRecord::Base.connection.execute(@sql)
			@notificacion << "<script>new Effect.Fade('list');</script>"
		end

		if @option == "custom"
			for id in @ids
				@usuario = Usuariosbloqueados.find(id)
				@usuario.destroy
				@notificacion << "<script>new Effect.Fade('u_#{id}');</script>"
			end
		end
		render(:text => @notificacion)
	end


	##################################################################################################################
	# block : blockea usuarios malebolos 
	###
	def block
		@id = params['id']
		@sql = "INSERT INTO usuariosbloqueados( id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio )
			  SELECT id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio FROM usuarios WHERE id =#{@id}"
		

		## no se si esto es la manera mas elegante de ejecutar un query complejos..
	    	ActiveRecord::Base.establish_connection
		ActiveRecord::Base.connection.execute(@sql)

		@usuario = Usuario.find(params[:id])
		@usuario.destroy
		@notificacion = "<small style='color:red;'>Usuario Bloqueado</small><script>setTimeout(\"new Effect.Fade('u_#{@id}');\", 500)</script>"

		render(:text => @notificacion)
	end


	##################################################################################################################
	# block : blockea usuarios malebolos 
	###
	def desblock
		@id = params['id']
	
		#busco si el usuario que quiere ser desbloqueado a sido creado en la tabla oficial.
		@usuarioBlock = Usuariosbloqueados.find(params[:id])
		@u = Usuario.find(:first, :conditions => ["usuario = ?", @usuarioBlock.usuario])		

		if @u.blank?
			@sql = "INSERT INTO usuarios( id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio )
			  	SELECT id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio FROM usuariosbloqueados WHERE id =#{@id}"

	    	ActiveRecord::Base.establish_connection
			ActiveRecord::Base.connection.execute(@sql)

			@usuarioBlock.destroy
			@notificacion = "<script>setTimeout(\"new Effect.Fade('u_#{@id}');\", 500)</script>"
		else
			@notificacion = "<small style='color:green;'>Usuario no puede ser desbloqueado, su username ya ha sido tomado. este registro sera eliminado.</small>"
			@usuarioBlock.destroy
		end
		render(:text => @notificacion)
	end

	##################################################################################################################
	# makeMailList : Genera la lista de correo... por lote.
	###
	def makeMailList
		@ids = params[:por_lote]
		@notificacion = "<div class='alert alert-success'>×</a>"
		for id in @ids
			@usuario = Usuario.find(id)
			@notificacion << "#{@usuario.nombre} #{@usuario.apellido} &lt;#{@usuario.mail}&gt;"
		end	
		@notificacion << "</div>"
		render(:text => @notificacion)
	end

	##################################################################################################################
	# changeUserType : Cambia el tipo de usuario... por lote
	###
	def changeUserType
		@ids = params[:por_lote]
		@tipo = params[:t]
		@notificacion =""
		for id in @ids
			@usuario = Usuario.find(id)
			@dato = {"tipo"=> @tipo}
			@usuario.update_attributes(@dato)
			case @tipo
				when 'a'
					@notificacion << "<script>document.getElementById('tipo_u_#{id}').innerHTML = 'Alumno';</script>"
				when 'e'
					@notificacion << "<script>document.getElementById('tipo_u_#{id}').innerHTML = 'Ex-Alumno';</script>"
				when 'p'
					@notificacion << "<script>document.getElementById('tipo_u_#{id}').innerHTML = 'Profesor';</script>"
				when 'f'
					@notificacion << "<script>document.getElementById('tipo_u_#{id}').innerHTML = 'Amigo';</script>"
				when 'o'
					@notificacion << "<script>document.getElementById('tipo_u_#{id}').innerHTML = 'Otro';</script>"
				else
					@notificacion << "<script>document.getElementById('tipo_u_#{id}').innerHTML = 'ERROR!';</script>"
			end
		end	
		@notificacion << "<script>setTimeout(\"new Effect.Fade('formChangeType');\", 100)</script>"
		render(:text => @notificacion)
	end


	def logout
		CASClient::Frameworks::Rails::Filter.logout(self)
	end
	def login
		redirect_to CASClient::Frameworks::Rails::Filter.login_url(self)
	end

	##################################################################################################################
	# list : lista los usuarios
	###
	def list
		if verificaAdmin()==FALSE
			redirect_to :action => 'index'
		end
		#@personas_page, @usuarios = paginate(:usuarios, :per_page => 30)
		#@usuarios = Usuario.find(:all,:limit=>50)
		@usuarios = Usuario.paginate(:page => params[:page], :per_page => 30)

	end

	##################################################################################################################
	# live_search : busqueda bonita! 
	###
	def live_search
		if params[:search_type]
			@tipo = params[:search_type]
		else
			@tipo = "apellidos"
		end
		@texto = params[:txt]

		if (@texto == "") || (@texto == nil)
			@usuarios = Usuario.paginate(:page => params[:page], :per_page => 30)
		else
			if @tipo == "nombres"
				@usuarios  = Usuario.find(:all, :conditions => ["nombre LIKE ?", '%' + @texto + '%'])
			end
			if @tipo == "apellidos"
				@usuarios  = Usuario.find(:all, :conditions => ["apellido LIKE ?", '%' + @texto + '%'])
			end
			if @tipo == "mail"
				@usuarios  = Usuario.find(:all, :conditions => ["mail LIKE ?", '%' + @texto + '%'])
			end
			if @tipo == "usuario"
				@usuarios  = Usuario.find(:all, :conditions => ["usuario LIKE ?", '%' + @texto + '%'])
			end
		end	

    		render(:layout => false)

	end	

	##################################################################################################################
	# checkUser : Verifica si el usuario existe
	###
	def checkUser
		@usuario = Usuario.find(:all, :conditions => ["usuario = ? ", params[:user]])
		if @usuario.blank?
			@notificacion = "Ok!"
		else
			@notificacion = "Ocupado!"
		end
		render(:text => @notificacion)
	end

	##################################################################################################################
	#  userIsAdmin: Agrega usuario a la administracion de PERSONAS
	###
	def userIsAdmin
		@accion = params[:accion]
		@user = params[:id]

		@usuario = Usuario.find(@user)
		
		if @accion == "y"

			@datos = {"admin"=>"si"}
			@notificacion = "<a href'#' onclick='if (confirm(\"Realmente desea que el usuario  #{@usuario.nombre} #{@usuario.apellido} ya no sea Administrador?\")) new Ajax.Updater({success:\"llave_#{@usuario.id}\"}, \"/usuarios/userIsAdmin/#{@usuario.id}?accion=n\", {asynchronous:true, evalScripts:true}); return false;'><img src='../../images/key.png'></a>"
			
		else
			@datos = {"admin"=>"no"}
			@notificacion = "<a href'#' onclick='if (confirm(\"Realmente desea que el usuario  #{@usuario.nombre} #{@usuario.apellido} sea Administrador de Personas?\")) new Ajax.Updater({success:\"llave_#{@usuario.id}\"}, \"/usuarios/userIsAdmin/#{@usuario.id}?accion=y\", {asynchronous:true, evalScripts:true}); return false;'><img src='../../images/key_gris.png'></a>"
		end

		@usuario.update_attributes(@datos)
		render(:text => @notificacion)
	end	
	

	##################################################################################################################
	# checkMail : Verifica si el mail existe
	###
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
	# signup : genera formulario y envia a "create"
	###
	def signup
		@usuario = Usuario.new
		@captcha = generateUniqueHexCode(6)
		cookies[:capt] = @captcha
	end


	##################################################################################################################
	# editPublico : formulario de edicion de usuarios
	###
	def editPublico
		@id = params[:id]
		@t = params[:t]
		@usuario = Usuario.find(:first, :conditions => ["id = ? AND token = ?",@id,@t])
	end


	##################################################################################################################
	# edit : formulario de edicion de usuarios
	###
	def edit
		@id = params[:id]
		@usuario = Usuario.find(params[:id])

		# hago la consulta solo para comparar usuario logeado vs usuario a editar
		@loged = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
	end


	##################################################################################################################
	# update : actualiza registros en la base de datos (usuarios)
	###
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

	##################################################################################################################
	# create : crea usuarios en la base de datos.
	###
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

	##################################################################################################################
	# confirmacion : Pantalla en blanco, para informacion, novedades.. etc.
	###
	def confirmacion	    
		render :layout => 'publico'	
	end


	##################################################################################################################
	# destroy : Elimina Usuarios
	###
	def destroy
		@usuario = Usuario.find(params[:id])
		@usuario.destroy
	end

	##################################################################################################################
	# acerca : Info del sitio
	###
	    def acerca

	    end

	##################################################################################################################
	# verificaAdmin : verifica si el usuario actual es admin o no
	###
	def verificaAdmin()
		@user = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
		@resp = FALSE
		if @user.admin == "si"
			@resp = TRUE
			return @resp
		else
			return @resp
		end
	end

	##################################################################################################################
	# verificaUsuario : verifica si el usuario actual es el mismo usuario que este intenta editar
	###
	def verificaUsuario(idUsuarioEditado)

		if Usuario.exists?(['usuario = ? AND id = ?',session[:cas_user], idUsuarioEditado])
			@resp = TRUE
			return @resp
		else
			@resp = FALSE
			return @resp
		end
	end
	##################################################################################################################
	# generateUniqueHexCode : Generador de Numeros Hexadecimales al Azar
	###
	def generateUniqueHexCode(codeLength)
		validChars = ("A".."F").to_a + ("0".."9").to_a
		length = validChars.size
		hexCode = ""
		1.upto(codeLength) { |i| hexCode << validChars[rand(length-1)] }
  	  	hexCode
	end

	def fromwikitopersons
		mw = MediaWiki::Gateway.new('http://wiki.ead.pucv.cl/api.php')
		mw.login('rodrigomt', '1dvuvvdu')
		@persons = Usuario.find(:all)
		for p in @persons
			puts "\n Buscando #{p.nombre} #{p.apellido}"
			n = p.nombre.split(" ")
			a = p.apellido.split(" ")
			unless a[0].blank?
				@result = mw.list("#{n[0]} #{a[0]}")
				if @result.length > 0
					p.wikipage = "http://wiki.ead.pucv.cl/index.php/#{MediaWiki::wiki_to_uri(@result.first)}"
					puts p.wikipage
				end
				
			end
		end
	end
end
