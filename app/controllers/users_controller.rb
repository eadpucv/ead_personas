class UsersController < ApplicationController
	before_action CASClient::Frameworks::Rails::Filter, :except => [ :data_for_wp, :signup, :editPublico, :update, :create, :checkUser, :checkMail, :enviaRecuperaMail, :recuperacionDatos, :new, :recovery, :recovery_enpoint, :passwordreset, :eula]
	require 'media_wiki'

	# Carga el buscador y el resultado paginado segun corresponda.
	def index
		@admin = is_admin
		if !params[:user_search].nil?
			search = params[:user_search]
			@users = User.where("nombre LIKE ? OR apellido LIKE ? OR mail LIKE ?", "%#{search}%","%#{search}%","%#{search}%").order(id: :desc).paginate(:page => params[:page], :per_page => 15)
		elsif !params[:filtro].nil? && params[:filtro] == "bloqueados"
			@users = User.where(status: false).order(id: :desc).paginate(:page => params[:page], :per_page => 15)
		else
			@users = User.order(id: :desc).paginate(:page => params[:page], :per_page => 15)
		end
	end

	# Muestra el perfil de un usuario.
	def show
		@user = User.find(params[:id])
	end

	# Inicia el flujo de creacion para nuevos usuarios.
	def new
		@user = User.new
		@opciones_tipo = [
			['Selecciona', ''],
			['Alumno(a)', 'a'],
			['Profesor(a)', 'p'],
			['Ex-alumno(a)', 'exa'],
			['Ex-profesor(a', 'exp'],
			['Amigo(a)', 'f'],
			['Otro(a)', 'o']
		]
		@opciones_carrera = [
			['Selecciona', ''],
			['Arquitectura', 'arq'],
			['Diseño', 'dis'],
			['Diseño Gráfico', 'dis_dg'],
			['Diseño Industrial', 'dis_di'],
			['Magister en Arquitectura y Diseño', 'mg']
		]
	end

	# Culmina el flujo de creacion de nuevos usuarios.
	def create
		# Creo el nuevo registro, con la informacion aportada.
		@user = User.new(user_params)
		# Verifico el recaptcha.
		if verify_recaptcha()
			# Aseguro la password y creo un token para el usuario.
			@user.password = Digest::SHA1.hexdigest("#{params[:user][:password]}")
			@user.token = generateUniqueHexCode(10)
			# Verifico si se creo el nuevo registro.
			if @user.save
				# Envio el mensaje de bienvenida.
				# UserMailer.registration_confirmation(@usuario).deliver
				redirect_to login_path
			else
				# No se pudo crear el nuevo registro.
				flash[:notice] = "No fue posible crear el usuario, verifica los datos y vuelve a intentarlo."
				flash[:error] = @user.errors.full_messages
				redirect_to new_user_path
			end
		else
			# El recaptcha no paso la verificacion.
			flash[:notice] = "No fue posible crear el usuario, ya que la verificacion captcha no fue superada."
			redirect_to new_user_path
		end
	end

	# Inicia el flujo de edicion para usuarios.
	def edit
		@opciones_tipo = [
			['Selecciona', ''],
			['Alumno(a)', 'a'],
			['Profesor(a)', 'p'],
			['Ex-alumno(a)', 'exa'],
			['Ex-profesor(a', 'exp'],
			['Amigo(a)', 'f'],
			['Otro(a)', 'o']
		]
		@opciones_carrera = [
			['Selecciona', ''],
			['Arquitectura', 'arq'],
			['Diseño', 'dis'],
			['Diseño Gráfico', 'dis_dg'],
			['Diseño Industrial', 'dis_di'],
			['Magister en Arquitectura y Diseño', 'mg']
		]
		if is_admin || edit_my_own_user(params[:id])
			@user = User.find(params[:id])
		else
			redirect_to  root_path
		end
	end

	# Culmina el flujo de edicion de usuarios.
	def update
		@user = User.find(params[:id])
		if params[:user][:password] == params[:user][:password_confirmation] && params[:user][:password] != ''
			@user.password = Digest::SHA1.hexdigest("#{params[:user][:password]}")
			@user.token = generateUniqueHexCode(10)
			@user.save!
		end
			#flash[:notice] = "Contraseña Actualizada."
			#redirect_to edit_user_path
		if @user.update_attributes(user_params)
			flash[:notice] = "Los datos se han actualizado correctamente."
			redirect_to edit_user_path
		else
			flash[:notice] = "No fue posible crear el usuario, verifica los datos y vuelve a intentarlo."
			flash[:error] = @user.errors.full_messages
			redirect_to edit_user_path
		end
	end

	# Perfil publico del usuario.
	def profile
		if is_admin || edit_my_own_user(params[:id])
			if User.exists?(params[:id])
				@user = User.find(params[:id])
				# Verifico que tengamos el dato.
				if @user.wikipage.to_s.strip.length != 0
					require 'open-uri'
					parse_data = Nokogiri::HTML(open(@user.wikipage))
					if parse_data.to_s.strip.length != 0
						# Ciudad y Pais
						ciudad_pais = ""
						if parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(4) > td')
							ciudad_pais = ciudad_pais + parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(4) > td').text
						end
						if parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(5) > td')
							if ciudad_pais.length > 2
								ciudad_pais = ciudad_pais + ", " + parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(5) > td').text
							else
								ciudad_pais = ciudad_pais + parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(5) > td').text
							end
						end
						# Nombre y Apellido
						nombre_apellido = ""
						if parse_data.at_css('span.given-name')
							nombre_apellido = nombre_apellido + parse_data.css('span.given-name').text
						end
						if parse_data.at_css('span.family-name')
							if nombre_apellido.length > 2
								nombre_apellido = nombre_apellido + " " + parse_data.css('span.family-name').text
							else
								nombre_apellido = nombre_apellido + parse_data.css('span.family-name').text
							end
						end
						@profile = {
							url_wiki: @user.wikipage,
							profile_img_name: parse_data.at_css('div.vcard > div > div > div > img') ? parse_data.css('div.vcard > div > div > div > img').attr('src').text : "",
							grado_academico: parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(1) > td') ? parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(1) > td').text : "",
							fecha_nacimiento: parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(2) > td') ? parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(2) > td').text : "",
							ano_ingreso: parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(3) > td') ? parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(3) > td').text : "",
							ciudad_pais: ciudad_pais,
							relacion_ead: parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(6) > td') ? parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(6) > td').text : "",
							carrera_ead: parse_data.at_css('table.wikitable.plantilla.persona > tr:nth-child(7) > td') ? parse_data.css('table.wikitable.plantilla.persona > tr:nth-child(7) > td').text : "",
							nombre_apellido: nombre_apellido,
							url_web_personal: parse_data.at_css('div.vcard > span > div.titulo > span:nth-child(3) > b > a') ? parse_data.css('div.vcard > span > div.titulo > span:nth-child(3) > b > a').text : "",
							url_wiki_edit: "<p class='no-data'><a href='" + @user.wikipage + "&action=edit' target='_self' title='Sin datos, por favor edite su perfil'>Sin datos, por favor edite su perfil</a></p>"
						}
					else
						# Wiki en blanco, pero existe.
						flash[:notice] = "La Wiki '#{@user.wikipage}' no tiene contenido, o la referencia esta corrupta."
					end
				else
					# Wiki no existe.
					flash[:notice] = "Este usuario no tiene Wiki vinculada."
				end
			end
		else
			redirect_to  root_path
		end
	end

	def user_admin
		if !params[:userid].nil?
			user = User.find_by_id(params[:userid])
			if user.admin == 'si'
				user.admin = 'no'
			else
				user.admin = 'si'
			end
			user.save
			render :json => { :status => true, :message => "Se cambio el parametro admin." }, :status => 201
		else
			render :json => { :status => false, :message => "No fue posible ejecutar la accion faltan parametros." }, :status => 200
		end
	end

	def user_lock
		if !params[:userid].nil?
			user = User.find_by_id(params[:userid])
			if user.status
				user.status = false
			else
				user.status = true
			end
			user.save
			render :json => { :status => true, :message => "Se cambio el parametro status." }, :status => 201
		else
			render :json => { :status => false, :message => "No fue posible ejecutar la accion faltan parametros." }, :status => 200
		end
	end

	def user_del
		if !params[:userid].nil?
			User.find_by_id(params[:userid]).destroy
			render :json => { :status => true, :message => "Se elimino el usuario." }, :status => 201
		else
			render :json => { :status => false, :message => "No fue posible eliminar el usuario." }, :status => 200
		end
	end

	def message
		if params[:to]
			@to_user = User.find_by_id(params[:to])
		else
			redirect_to  root_path
		end
	end

	def send_message
		if !params[:targetid].nil? && !params[:asunto].nil? && !params[:mensaje].nil?
			user_target = User.find_by_id(params[:targetid])
			UserMailer.send_message(user_target.mail, params[:asunto], params[:mensaje]).deliver_now
			flash[:notice] = "El mensaje se envio de forma exitosa."
		else
			flash[:notice] = "El no se pudo enviar."
		end
		redirect_to  root_path
	end

	def export
		require 'sanitize'
		@users = User.all
		respond_to do |format|
			format.csv do
				headers['Content-Disposition'] = "attachment; filename=\"ead_usuarios.csv\""
				headers['Content-Type'] ||= 'text/csv'
			end
		end
	end

	def advanced_exporter
		if request.post?
			# Es la exportacion parametrizada
		else
			# Es desplegar la vista del buscador avanzado.
		end
	end

	def recovery
	end

	def passwordreset
		if request.post? && !params[:id].blank?
			user = User.find(params[:id])
			if params[:user][:password] == params[:user][:password_confirmation] && params[:user][:password] != ''
				user.password = Digest::SHA1.hexdigest("#{params[:user][:password]}")
				user.token = generateUniqueHexCode(10)
				user.reset_token = nil
				user.save!
				redirect_to  root_path
			end
		else
			if !params[:hash].nil?
				@user = User.find_by_reset_token(params[:hash])
			else
				@user = nil
				redirect_to  root_path
			end
		end
	end

	def recovery_enpoint
		if !params[:txt].blank? && !params[:kind].nil?
			if params[:kind] == 'email'
				user = User.find_by_mail(params[:txt])
			elsif params[:kind] == 'rut'
				user = User.find_by_rut(params[:txt])
			else
				user = nil
			end
			if !user.nil?
				user.reset_token = Digest::SHA1.hexdigest(generateUniqueHexCode(10))
				user.save!
				UserMailer.recuperacion_datos(user).deliver_now
				render :json => { :status => true, :message => "El usuario fue encontrado y se envio un mensaje al correo electronico registrado. <a target='_self' href='http://personas.ead.pucv.cl'>OK</a>" }, :status => 201
			else
				render :json => { :status => false, :message => "No fue posibel encontrar al usuario con la informacion proporcionada." }, :status => 200
			end
		else
			render :json => { :status => false, :message => "Los parametros proporcionados no son suficientes." }, :status => 200
		end
	end

	def eula
	end

	def user_params
		params.require(:user).permit(
			:rut,
			:nombre,
			:apellido,
			:mail,
			:telefono_fijo,
			:telefono_cel,
			:direccion,
			:ciudad,
			:pais,
			:tipo,
			:anoingreso,
			:carrera,
			:web,
			:twitter,
			:flickr,
			:usuario,
			:bio,
			:wikipage,
			:status
			)
	end

end

	# # USUARIO
	# def data_for_wp
	# 	if params[:key].to_s == "d0c0e3d43f100c138b2142fd48eaac32"
	# 		@usuario = Usuario.find(:first, :conditions => ["usuario = ?",params[:u]])
	# 		render(:json => @usuario)
	# 	else
	# 		render(:json => {"error"=>"key_error"})
	# 	end
	# end

	# #
	# def editPublico
	# 	@id = params[:id]
	# 	@t = params[:t]
	# 	@usuario = Usuario.find(:first, :conditions => ["id = ? AND token = ?",@id,@t])
	# 	if @usuario.nil?
	# 		redirect_to  root_path
	# 	end
	# end

	# # Upadate user attributes.
	# def update
	# 	@usuario = Usuario.find(params[:id])
	# 	if isAdmin? || params[:t] == @usuario.token || editMyOwnUser?(params[:id])
	# 		if params[:usuario][:password]
	# 			if params[:usuario][:password] == params[:contrasena_rep]
	# 				@usuario.password = Digest::SHA1.hexdigest("#{params[:usuario][:password]}")
	# 				@usuario.save!
	# 				flash[:notice] = "Contraseña Actualizada"		
	# 				redirect_to  root_path
	# 			else
	# 				flash[:notice] = "Las contraseñas no coinciden"		
	# 				redirect_to :action => 'edit', :id=> params[:id]
	# 			end
	# 		else
	# 			if @usuario.update_attributes(params[:usuario])
	# 				flash[:notice] = "Los datos se han actualizado correctamente."		
	# 				redirect_to  root_path
	# 			else
	# 				flash[:notice] = "Tienes problemas con tu formulario, Completa todos los datos"		
	# 				redirect_to :action => 'edit', :id=> params[:id]					
	# 			end
	# 		end
	# 	end
	# end

	# # CHECKS
	# def checkUser
	# 	@usuario = Usuario.find(:all, :conditions => ["usuario = ? ", params[:user]])
	# 	if @usuario.blank?
	# 		@notificacion = '<span class="label label-success">disponible</span>'
	# 	else
	# 		@notificacion = '<span class="label label-important">no disponible</span>'
	# 	end
	# 	render(:text => @notificacion)
	# end

	# # Verifica email.
	# def checkMail
	# 	@usuario = Usuario.find(:all, :conditions => ["mail = ? ", params[:mail]])
	# 	if @usuario.blank?
	# 		@notificacion = '<span class="label label-success">disponible</span>'
	# 	else
	# 		@notificacion = '<span class="label label-important">no disponible</span>'
	# 	end
	# 	render(:text => @notificacion)
	# end

	# # Recupera Correo
	# def enviaRecuperaMail
	# 	@tipo ="recupera"
	# 	@usuario = Usuario.find(:first, :conditions => ["mail = ?", params[:mail]])
	# 	if @usuario.nil?
	# 		flash[:notice] = "Este correo no figura en nuestro registro. Tal vez te registraste con un correo antiguo que ya no usas."
	# 		redirect_to :action => 'recuperacionDatos'
	# 	else
	# 		UserMailer.recuperacion_datos(@usuario).deliver
	# 		flash[:notice] = "Los datos del usuario #{@usuario.nombre}  #{@usuario.apellido} [#{@usuario.usuario}] han sido enviados a la direccion de mail."
	# 		redirect_to root_path
	# 	end
	# end
