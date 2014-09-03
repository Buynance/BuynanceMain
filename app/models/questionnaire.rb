class Questionnaire < ActiveRecord::Base

	has_many :questions
	belongs_to :questionnaire_completed
	after_initialize :set_answers_array

	def self.make(question_array, name, description = "Not Available")
		questionnaire = Questionnaire.create(name: name, description: description)
		question_array.each do |question|
			Question.create(question_text: question, questionnaire_id: questionnaire.id )
		end
	end

	private

	def set_answers_array
		#self.answers = Array.new(questions.size) unless self.id.nil?
		unless self.id.nil?
			(0...questions.size).each do |i|
				class <<self
      				self
    			end.class_eval do
					attr_accessor "answer#{i}"
				end
			end
		end
	end

end
