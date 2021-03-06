 class DialerDashboardsController < ApplicationController

	layout "dialer_layout"

	before_filter :require_rep_dialer_friends, except: [:home, :iso_home]

	force_ssl if: :not_linkedin?

	def home
		#pluggable_js(is_production: is_production)
		redirect_to "/family"

	end

	def iso_home

	end

	def account
		@representative = current_rep_dialer_friends
		pluggable_js(is_production: is_production, email: @representative.email, is_pending: @representative.awaiting_acceptance?, is_accepted: @representative.accepted?, is_rejected: @representative.rejected?)
		if @representative.awaiting_questionnaire?
			redirect_to action: :questionnaire
		end
	end

	def setup
		@representative = current_rep_dialer_friends

	end

	def setup_action
		@representative = current_rep_dialer_friends
		if @representative.update_attributes(representative_params)
			@representative.add_paypal
			redirect_to action: :account
		else
			render action: :setup
		end
	end

	def questionnaire
		@rep_dialer = current_rep_dialer_friends
		pluggable_js(is_production: is_production, email: @rep_dialer.email)
		@questionnaire = Questionnaire.find_by(name: "rep_questionnaire")
	end

	def questionnaire_action
		@rep_dialer = current_rep_dialer_friends
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

    def not_linkedin?
    	((params[:linkedin] != "true") and !Rails.env.development?)
    end

end
