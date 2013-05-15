class SessionsController < ApplicationController
	def create
raise request.env["omniauth.auth"].to_yaml
	end

	def destroy
	  session[:user_id] = nil
	  redirect_to root_url, :notice => "Signed out!"
	end
end
