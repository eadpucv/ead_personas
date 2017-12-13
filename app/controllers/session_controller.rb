class SessionController < ApplicationController
	before_filter :check_user, :except => [:create, :destroy]

	def new
	end

	def create
		user = User.authenticate(params[:email], params[:password])
		if user
			session[:user] = {
				id: user.id,
				nombre: user.nombre,
				apellido: user.apellido,
				usuario: user.usuario,
				mail: user.mail,
				wikipage: user.wikipage,
				admin: user.admin,
				status: user.status
			}
			puts "---------------------------"
			puts "Estoy en la session."
			puts session.inspect
			puts "---------------------------"
			redirect_to root_url, :notice => "Logged in!"
		else
			flash.now.alert = "Invalid email or password"
			render "new"
		end
	end

	def destroy
		session[:user] = nil
		redirect_to root_url, :notice => "Logged out!"
	end

end
