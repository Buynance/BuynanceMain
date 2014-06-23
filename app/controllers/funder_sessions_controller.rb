class FunderSessionsController < ApplicationController
	before_filter :require_no_funder, :only => [:new, :create]
	layout "funder_layout"

	def new
		@funder_session = FunderSession.new
	end

	def create
    @funder_session = FunderSession.new(params[:funder_session])
    if @funder_session.save
      redirect_to controller: "funder_dashboards", action: "main" 
    else
      render :action => :new
    end
  end

  def destroy
    current_funder_session.destroy
    redirect_back_or_default new_funder_session_url
  end
end