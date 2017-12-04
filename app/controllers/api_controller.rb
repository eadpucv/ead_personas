class ApiController < ApplicationController
	# # before_action :doorkeeper_authorize!
	# respond_to    :json

	# # GET /me.json
	# def me
	# 	respond_with current_resource_owner
	# end

	# private

	# # Find the user that owns the access token
	# def current_resource_owner
	# 	# User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
 #        if doorkeeper_token
 #          @current_user ||= User.find(doorkeeper_token.resource_owner_id)
 #        end
	# end



  before_action :doorkeeper_authorize!

  def show
    render json: current_resource_owner.as_json(except: :password)
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end
