class Usuario < ActiveRecord::Base
	validates_presence_of :usuario
	validates_presence_of :mail
	validates_presence_of :nombre
	validates_presence_of :apellido	

	validates_uniqueness_of :usuario
	validates_uniqueness_of :mail
end
