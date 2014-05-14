class AdminController < ApplicationController
before_filter CASClient::Frameworks::Rails::Filter


##############
#### MAIL LIST

	# mailList : En base a ciertos filtros, se genera una lista de correo.
	def maillist
		if isAdmin?
			@loged = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
		else
			redirect_to  root_path
		end
	end


	# mailList : lee parametros de maillist
	def maillistgenerator
		if isAdmin?
			@tipo 		= params[:tipo]
			@carrera 	= params[:carrera]
			@anodesde 	= params[:date][:anodesde]
			@anohasta 	= params[:date][:anohasta]
			@tipoLista		=params[:tipolista]
			@it		= 1

			if @anodesde.to_i > @anohasta.to_i
				@mails = "<b>Error, Mal formato</b>"
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
		else
			redirect_to  root_path
		end		
	end

	def makeMailList
		if isAdmin?
			@ids = params[:por_lote]
			@notificacion = "<div class='alert alert-success'>"
			for id in @ids
				@usuario = Usuario.find(id)
				@notificacion << "#{@usuario.nombre} #{@usuario.apellido} &lt;#{@usuario.mail}&gt;"
			end	
			@notificacion << "</div>"
			render(:text => @notificacion)
		else
			redirect_to  root_path
		end
	end	

########################
#### USUARIOS BLOQUEADOS

	# userIsAdmin : genera listado de usuarios bloqueados
	def userIsAdmin
		if isAdmin?
			@usuario = Usuario.find(params[:id])
			if params[:accion] == "y"
				@datos = {"admin"=>"si"}			
			else
				@datos = {"admin"=>"no"}
			end
			@usuario.update_attributes(@datos)
		else
			redirect_to  root_path
		end
	end

	# blockedUsers : genera listado de usuarios bloqueados
	def blockedUsers
		if isAdmin?
			@usuarios = Usuariosbloqueados.find(:all)
		else
			redirect_to  root_path
		end
	end

	# blockXlote : bloquear bobos por lote..
	def blockXlote
		if isAdmin?
			@ids = params[:por_lote]
			@notificacion = ""
			for id in @ids
				@sql = "INSERT INTO usuariosbloqueados( id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio )
				  SELECT id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio FROM usuarios WHERE id =#{id}"
		
			   ActiveRecord::Base.establish_connection
				ActiveRecord::Base.connection.execute(@sql)
				@usuario = Usuario.find(id)
				@usuario.destroy
			end
			render(:text => @ids.to_json)
		else
			redirect_to  root_path
		end
	end

	# blockXlote : bloquear bobos por lote..
	def deleteXlote
		if isAdmin?
			@ids 	= params[:por_lote]
			@option = params[:o]
			@notificacion = ""

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
				end
			end
			render(:text => @ids.to_json)
		else
			redirect_to  root_path
		end
	end


	# block : blockea usuarios malebolos 
	def block
		if isAdmin?
			@id = params['id']
			@sql = "INSERT INTO usuariosbloqueados( id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio )
				  SELECT id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio FROM usuarios WHERE id =#{@id}"
			
			## no se si esto es la manera mas elegante de ejecutar un query complejos..
		   ActiveRecord::Base.establish_connection
			ActiveRecord::Base.connection.execute(@sql)

			@usuario = Usuario.find(params[:id])
			@usuario.destroy
		else
			redirect_to  root_path
		end
	end

	# desblock : Desbloque usuarios
	def desblock
		if isAdmin?
			@id = params['id']
			@usuarioBlock = Usuariosbloqueados.find(params[:id])

			#busco si el usuario que quiere ser desbloqueado a sido creado en la tabla oficial.
			@u = Usuario.find(:first, :conditions => ["usuario = ?", @usuarioBlock.usuario])		

			if @u.blank?
				@sql = "INSERT INTO usuarios( id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio )
				  	SELECT id, rut, nombre, apellido, mail, mail_2, mail_3, telefono_fijo, telefono_cel, direccion, tipo, anoingreso, carrera, web, twitter, flickr, usuario, password, token, bio FROM usuariosbloqueados WHERE id =#{@id}"

		    	ActiveRecord::Base.establish_connection
				ActiveRecord::Base.connection.execute(@sql)
				@usuarioBlock.destroy
			else
				@usuarioBlock.destroy
			end
		else
			redirect_to  root_path
		end
	end


##################
# CHANGE USER TYPE

	def changeUserType
		if isAdmin?
			@ids = params[:por_lote]
			@tipo = params[:t]
			@notificacion = Array.new()
			for id in @ids
				@usuario = Usuario.find(id)
				@dato = {"tipo"=> @tipo}
				@usuario.update_attributes(@dato)
				case @tipo
					when 'a'
						@notificacion << ["#{id}","Alumno"]
					when 'e'
						@notificacion << ["#{id}","Ex-Alumno"]
					when 'p'
						@notificacion << ["#{id}","Profesor"]
					when 'f'
						@notificacion << ["#{id}","Amigo"]
					when 'o'
						@notificacion << ["#{id}","Otro"]
				end
			end	
			render(:text => @notificacion.to_json)
		else
			redirect_to  root_path
		end
	end


#################
# LISTAR Y BUSCAR

	def list
		if isAdmin?
			if params[:txt]
				@usuarios = Usuario.paginate(:conditions=>["nombre LIKE ? OR apellido LIKE ? OR mail LIKE ? OR usuario LIKE ?","%"+params[:txt]+"%","%"+params[:txt]+"%","%"+params[:txt]+"%","%"+params[:txt]+"%"], :page => params[:page], :per_page => 30)
			else
				@usuarios = Usuario.paginate(:page => params[:page], :per_page => 30)
			end
		else
			redirect_to  root_path
		end
	end

end
