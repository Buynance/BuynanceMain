class QuestionnaireCompleted < ActiveRecord::Base
	belongs_to :questionnaire
	belongs_to :rep_dialer

	
end
