# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def set_url_for_bar(url)
		if session[:admin] == "si"
			admin_list_url
		else
			home_user_url
		end
	end

	def isAdmin?()
		if session[:cas_user]
			@user = Usuario.find(:first, :conditions =>["usuario = ?", session[:cas_user]])
			if @user.admin == "si"
				true
			else
				false
			end
		else
			false
		end
	end
end
