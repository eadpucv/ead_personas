class SessionController < ApplicationController
	
	# Step of logout
	def destroy
		session[:user_id] = nil
		redirect_to root_url, :notice => "Signed out!"
	end

	# Logout
	def logout
		CASClient::Frameworks::Rails::Filter.logout(self)
	end

	# Login
	def login
		redirect_to CASClient::Frameworks::Rails::Filter.login_url(self)
	end
	
end
