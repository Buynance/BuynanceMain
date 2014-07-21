class TranslatorPage < ActiveRecord::Base
	has_many :translator_values

	def get(key, locale = 'en')
		return translator_values.where("key = ? AND locale = ?", key, locale).first.value
	end


end
