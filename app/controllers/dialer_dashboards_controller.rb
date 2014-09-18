 class DialerDashboardsController < DialerApplicationController

	layout "dialer_layout"

	before_filter :require_rep_dialer, except: [:home]

	def home
		

	end

	def account
		@representative = current_rep_dialer
		if @representative.awaiting_questionnaire?
			redirect_to action: :questionnaire
		end
	end

	def setup
		@representative = current_rep_dialer

	end

	def setup_action
		@representative = current_rep_dialer
		if @representative.update_attributes(representative_params)
			@representative.add_paypal
			redirect_to action: :account
		else
			render action: :setup
		end
	end

	def questionnaire
		@rep_dialer = current_rep_dialer
		@questionnaire = Questionnaire.find_by(name: "rep_questionnaire")
	end

	def questionnaire_action
		@rep_dialer = current_rep_dialer
		@questionnaire = Questionnaire.find_by(name: "rep_questionnaire")
		@rep_dialer.assign_attributes(representative_params)
		@rep_dialer.current_step = "questionnaire"
		@questionnaire.assign_attributes(questionnaire_params)
		if @questionnaire.valid? and @rep_dialer.valid?
			@questionnaire.save
			@rep_dialer.save
			(0...@questionnaire.questions.size).each do |i|
				question = @questionnaire.questions[i]
				Answer.create(answer_text: @questionnaire.send("answer#{i+1}".to_sym),
					question_id:  @questionnaire.questions[i].id, 
					rep_dialer_id: @rep_dialer.id)
			end
			QuestionnaireCompleted.create(questionnaire_id: @questionnaire.id, rep_dialer_id: @rep_dialer.id)
			@rep_dialer.complete_questionnaire
			redirect_to action: :account
		else
			render action: :questionnaire
		end
	end

	private

	def representative_params
      return params.require(:rep_dialer).permit(:mobile_number, :agree_confirmation) 
    end

    def questionnaire_params
    	return params.require(:questionnaire).permit(:answer1, :answer2, :answer3, :answer4, :answer5)
    end

end
