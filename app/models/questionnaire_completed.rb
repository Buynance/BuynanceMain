class QuestionnaireCompleted < ActiveRecord::Base
	has_one :questionnaire
	has_one :rep_dialer

	
end
