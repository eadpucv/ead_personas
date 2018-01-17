class AddAcceptTermsAndConditionsToUser < ActiveRecord::Migration
	def change
		add_column :users, :accept_terms_and_conditions, :boolean, default: 1, null: false, :after => :reset_token
	end
end
