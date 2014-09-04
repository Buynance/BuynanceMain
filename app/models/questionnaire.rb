class Questionnaire < ActiveRecord::Base

	has_many :questions, :dependent => :destroy
	has_many :questionnaire_completed, :dependent => :destroy
	after_initialize :set_answers_array
	validate :answers_validation, on: :update

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
			(1..questions.size).each do |i|
				class <<self
      				self
    			end.class_eval do
					attr_accessor "answer#{i}"
					#validates "answer#{i}", presence: true, allow_blank: false
				end
			end
		end
	end

	private

	def answers_validation
		(0...questions.size).each do |i|
			if (self.send("answer#{i+1}".to_sym).blank?)
				errors.add("answer#{i+1}".to_sym, "Please complete question ##{i+1}")
			end
		end
	end

end
