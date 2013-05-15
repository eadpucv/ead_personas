class Usuario < ActiveRecord::Base
	validates_presence_of :usuario
	validates_presence_of :mail
end
