class AddStatusToUsers < ActiveRecord::Migration
	def change
		add_column :users, :status, :boolean, default: 1, null: false, :after => :o_token
	end
end
