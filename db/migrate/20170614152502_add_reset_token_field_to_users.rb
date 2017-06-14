class AddResetTokenFieldToUsers < ActiveRecord::Migration
	def change
		add_column :users, :reset_token, :string, default: nil, null: true, :after => :o_token
	end
end
