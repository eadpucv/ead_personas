class SessionController < ApplicationController
	before_filter :check_user, :except => [:create, :destroy]

	def new
		# session[:return_to] = "https://www.google.com"
	end

	def create
		result = User.authenticate(params[:email], params[:password])
		if !result[:user].nil?
			session[:user] = {
				id: result[:user].id,
				nombre: result[:user].nombre,
				apellido: result[:user].apellido,
				usuario: result[:user].usuario,
				mail: result[:user].mail,
				wikipage: result[:user].wikipage,
				admin: result[:user].admin,
				status: result[:user].status
			}
			if params.has_key?(:remember_me)
				cookies.signed[:user_id] = { value: result[:user].id.to_s, expires: 2.weeks.from_now }
			end
			# if params.has_key?(:redirect_uri)
			# 	redirect_to params[:redirect_uri], params: request.parameters
			# 	# redirect_to new_user_path(request.parameters)
			# else
				redirect_to session[:return_to] || root_url, :notice => "Sesion iniciada!" # Esto se esta ejecutando cuando me logeo y ya existo.
			# end
		else
			redirect_to root_url, :notice => result[:notice]
		end
	end

	def destroy
		session[:user] = nil
		cookies.delete :user_id
		redirect_to session[:return_to] || root_url, :notice => "Sesion cerrada!"
	end

end
