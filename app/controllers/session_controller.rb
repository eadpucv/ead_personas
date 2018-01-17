class SessionController < ApplicationController
	before_filter :check_user, :except => [:create, :destroy]

	def new
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
			if params[:redirect_uri]
				redirect_to params[:redirect_uri]
			else
				redirect_to root_url, :notice => "Sesion iniciada!"
			end
		else
			redirect_to root_url, :notice => result[:notice]
		end
	end

	def destroy
		session[:user] = nil
		redirect_to root_url, :notice => "Sesion cerrada!"
	end

end
