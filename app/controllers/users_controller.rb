class UsersController < ApplicationController
	before_action CASClient::Frameworks::Rails::Filter, :except => [ :data_for_wp, :signup, :editPublico, :update, :create, :checkUser, :checkMail, :enviaRecuperaMail, :recuperacionDatos, :new]
	require 'media_wiki'

	# Carga el buscador y el resultado paginado segun corresponda.
	def index
		@admin = is_admin
		if !params[:user_search].nil?
			search = params[:user_search]
			@users = User.where("nombre LIKE ? OR apellido LIKE ? OR mail LIKE ?", "%#{search}%","%#{search}%","%#{search}%").order(id: :desc).paginate(:page => params[:page], :per_page => 15)
		else
			@users = User.order(id: :desc).paginate(:page => params[:page], :per_page => 15)
		end
	end

	# Perfil publico del usuario.
	def profile
		if is_admin || edit_my_own_user(params[:user_id])
			if User.exists?(params[:user_id])
				@user = User.find(params[:user_id])
				# Verifico que tengamos el dato.
				if @user.wikipage.to_s.strip.length != 0
					wiki_data = get_wikipage(@user.wikipage)
					if wiki_data.to_s.strip.length != 0
						parse_data = Nokogiri::HTML(wiki_data)
						puts "kaosbite"
						puts wiki_data.inspect
						@profile = {
							url_wiki: @user.wikipage,
							profile_img_name: parse_data.css('div.vcard > div > div > div > img').attr('src').text,
							grado_academico: parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(1) > td').text,
							fecha_nacimiento: parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(2) > td').text,
							ano_ingreso: parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(3) > td').text,
							ciudad_pais: parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(4) > td').text + ", " + parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(5) > td').text,
							relacion_ead: parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(6) > td').text,
							carrera_ead: parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(7) > td').text,
							nombre_apellido: parse_data.css('span.given-name').text + " " + parse_data.css('span.family-name').text,
							url_web_personal: parse_data.css('div.vcard > span > div.titulo > span:nth-child(3) > b > a').text,
							url_wiki_edit: "<p class='no-data'><a href='" + @user.wikipage + "&action=edit' target='_self' title='Sin datos, por favor edite su perfil'>Sin datos, por favor edite su perfil</a></p>"
						}
					else
						# Wiki en blanco, pero existe.
						flash[:notice] = "La Wiki '#{@user.wikipage}' no tiene contenido, o la referencia esta corrupta."
					end
				else
					# Wiki no existe.
					flash[:notice] = "Este usuario no tiene Wiki."
				end
			end
		else
			redirect_to  root_path
		end
	end

	# Init new user creation flow.
	def new
		@user = User.new
		@opciones_tipo = [
			['', ''],
			['Alumno(a)', 'a'],
			['Profesor(a)', 'p'],
			['Ex-alumno(a)', 'a'],
			['Ex-profesor(a', 'a'],
			['Amigo(a)', 'a'],
			['Otro(a)', 'a']
		]
		@opciones_carrera = [
			['', ''],
			['Arquitectura', 'arquitectura'],
			['Diseño', 'diseño'],
			['Diseño Gráfico', 'diseño_grafico'],
			['Diseño Industrial', 'diseño:industrial'],
			['Magister en Arquitectura y Diseño', 'magister_en_arquitectura_y_diseño'],
		]
	end

	# Create new user.
	def create

		render :json => { :status => true, :message => "Se recibieron los datos", :params => params[:user] }, :callback => params[:callback], :status => 200

		# @usuario = Usuario.new(params[:usuario])
		# @mail = params[:usuario][:mail]
		# @username = params[:usuario][:usuario]
		# @wikipage = "#{params[:usuario][:nombre]} #{params[:usuario][:apellido]}"
		# @capt = params[:capt]
		# @flag = 0	
		# @capt_cookie = cookies[:capt]
		# if verify_recaptcha == true
		# 	if Usuario.exists?(:usuario=>@username) 
		# 		flash[:notice] = "El usuario #{@username} ya existe!!"
		# 		@flag=1
		# 		if Usuario.exists?(:mail=>@mail)
		# 			flash[:notice] = "El email #{@mail} ya existe!!"
		# 			@flag=1
		# 			if @usuario.apellido.blank?
		# 				flash[:notice] = "El campo Apellido esta vacio"
		# 				@flag=1
		# 			end	
		# 		end
		# 	end 
		# 	if (@flag==0)
		# 		if @usuario.save
		# 			@contrasena = Digest::SHA1.hexdigest("#{@usuario.password}")
		# 			@usuario.password = @contrasena
		# 			@usuario.token = generateUniqueHexCode(10)
		# 			@usuario.save
		# 			if @usuario.wikipage.blank? || @usuario.wikipage == "" || @usuario.wikipage.nil?
		# 				@wikipage = "#{params[:usuario][:nombre]} #{params[:usuario][:apellido]}"
		# 			else
		# 				@wikipage = @usuario.wikipage
		# 			end
		# 			begin
		# 				if @usuario.tipo == "a"
		# 					@tipo = "|Relación con la Escuela=Alumno  \n"
		# 				elsif @usuario.tipo == "p"
		# 					@tipo = "|Relación con la Escuela=Profesor  \n"
		# 				elsif @usuario.tipo == "e"							
		# 					@tipo = "|Relación con la Escuela=Ex-Alumno  \n"
		# 				elsif @usuario.tipo == "f"
		# 					@tipo = "|Relación con la Escuela=Amigo  \n"
		# 				elsif @usuario.tipo == "o"
		# 					@tipo = "|Relación con la Escuela=Otro  \n"
		# 				end
		# 				unless @usuario.carrera.blank?
		# 					@carrera = "|Carreras Relacionadas=#{@usuario.carrera.capitalize} \n"
		# 				end
		# 				@data = "{{Persona
		# 				|Nombre=#{@usuario.nombre}
		# 				|Apellido=#{@usuario.apellido}
		# 				#{@tipo}
		# 				#{@carrera}
		# 				}}"
		# 				casiopea_page = create_wikipage(@wikipage,@data,params[:usuario][:bio])
		# 				@usuario.wikipage = "http://wiki.ead.pucv.cl/index.php?title="+casiopea_page.to_s
		# 				@usuario.save!
		# 			rescue MediaWiki::APIError
		# 				flash[:notice] = "La pagina de la wiki ya existe < #{@wikipage} >, Tu cuenta se creo de igual manera, pero debes actualizar tus datos"		
		# 			end
		# 			UserMailer.registration_confirmation(@usuario).deliver
		# 			flash[:notice] = "Usuario Creado"
		# 			redirect_to root_path
		# 		else
		# 			flash[:notice] = "No se ha podido crear el usuario | verifica que el email o el usuario este disponible"
		# 			redirect_to :action => 'signup'
		# 		end
		# 	else
		# 		redirect_to :action => 'signup'
		# 	end
		# else
		# 	flash[:notice] = "El Captcha no coincide"
		# 	redirect_to :action => 'signup'
		# end
	end

	# Formulario de edicion de usuario.
	def edit
		if is_admin || edit_my_own_user(params[:user_id])
			@user = User.find(params[:user_id])
			puts @user.inspect
			puts "kaosbite"
		else
			redirect_to  root_path
		end
	end

	# Cerrar session.
	def logout
	end
















	# USUARIO
	def data_for_wp
		if params[:key].to_s == "d0c0e3d43f100c138b2142fd48eaac32"
			@usuario = Usuario.find(:first, :conditions => ["usuario = ?",params[:u]])
			render(:json => @usuario)
		else
			render(:json => {"error"=>"key_error"})
		end
	end

	#
	def home_user
	end

	#
	def signup
		@usuario = Usuario.new
	end

	#
	def editPublico
		@id = params[:id]
		@t = params[:t]
		@usuario = Usuario.find(:first, :conditions => ["id = ? AND token = ?",@id,@t])
		if @usuario.nil?
			redirect_to  root_path
		end
	end

	# Upadate user attributes.
	def update
		@usuario = Usuario.find(params[:id])
		if isAdmin? || params[:t] == @usuario.token || editMyOwnUser?(params[:id])
			if params[:usuario][:password]
				if params[:usuario][:password] == params[:contrasena_rep]
					@usuario.password = Digest::SHA1.hexdigest("#{params[:usuario][:password]}")
					@usuario.save!
					flash[:notice] = "Contraseña Actualizada"		
					redirect_to  root_path
				else
					flash[:notice] = "Las contraseñas no coinciden"		
					redirect_to :action => 'edit', :id=> params[:id]
				end
			else
				if @usuario.update_attributes(params[:usuario])
					flash[:notice] = "Los datos se han actualizado correctamente."		
					redirect_to  root_path
				else
					flash[:notice] = "Tienes problemas con tu formulario, Completa todos los datos"		
					redirect_to :action => 'edit', :id=> params[:id]					
				end
			end
		end
	end

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

	# Verifica email.
	def checkMail
		@usuario = Usuario.find(:all, :conditions => ["mail = ? ", params[:mail]])
		if @usuario.blank?
			@notificacion = '<span class="label label-success">disponible</span>'
		else
			@notificacion = '<span class="label label-important">no disponible</span>'
		end
		render(:text => @notificacion)
	end

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

	# Recupera datos
	def recuperacionDatos
	end

end
