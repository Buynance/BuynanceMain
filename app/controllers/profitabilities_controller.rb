class ProfitabilitiesController < ApplicationController
  before_filter :standardize_params, only: [:create]



  # GET /profitabilities/new
  def new
    @profitability = Profitability.new
    @saved_profitability = Profitability.find(params[:id]) if params[:id]
  end

  # POST /profitabilities
  # POST /profitabilities.json
  def create
    prs = profitability_params

    @profitability = Profitability.new(profitability_params)
    @is_daily_merchant_cash_advance_error = @profitability.errors.include?(:daily_merchant_cash_advance)
    @is_monthly_cash_collection_amount_error = @profitability.errors.include?(:monthly_cash_collection_amount)
    @is_total_monthly_bills_error = @profitability.errors.include?(:total_monthly_bills)
    
    respond_to do |format|
      if @profitability.save
        #AnonymousUserWorker.perform_async(request.remote_ip, @profitability.id)
        #@profitability.create_anonymous_user(request.remote_ip)
        format.html { redirect_to new_profitability_path(id: @profitability.id), notice: 'Profitability was successfully created.' }
        format.json { render action: 'show', status: :created, location: @profitability }
      else
        format.html { render action: 'new' }
        format.json { render json: @profitability.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profitability
      @profitability = Profitability.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profitability_params
      params.require(:profitability).permit(:monthly_cash_collection_amount, :gross_profit_margin,
                                            :projected_monthly_profit, :total_monthly_bills, :daily_merchant_cash_advance)
    end

    # remove $
    def standardize_params
      params[:profitability][:monthly_cash_collection_amount].gsub!( /\$/, '')
      params[:profitability][:total_monthly_bills].gsub!( /\$/, '')
      params[:profitability][:daily_merchant_cash_advance].gsub!( /\$/, '')
    end
end
