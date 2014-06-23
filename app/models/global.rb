class Global < ActiveRecord::Base

	self.inheritance_column = nil

	def self.add(variable_name, variable_value, variable_type)
		return Global.create(variable: variable_name, value: variable_value, type: variable_type)
	end

	def self.get(variable_name)
		global = Global.find_by(variable: variable_name)
		return Global.string_to_value(global.type.underscore, global.value)
	end

	def self.string_to_value(type, value)
		return value.to_f if type == "float"
		return value.to_i if type == "integer"
		return value      if type == "string"
		return nil
	end
end
