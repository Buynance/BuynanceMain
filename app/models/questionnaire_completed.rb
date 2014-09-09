class QuestionnaireCompleted < ActiveRecord::Base
	belongs_to :questionnaire, inverse_of: :questionnaire_completed
	belongs_to :rep_dialer

	
end
