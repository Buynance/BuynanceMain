class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
  def linkedin
    auth = env["omniauth.auth"]
    @rep_dialer = RepDialer.connect_to_linkedin(request.env["omniauth.auth"],current_rep_dialer)
    if @rep_dialer.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in @rep_dialer, :event => :authentication
      redirect_to dialer_account_dialer_dashboards_path
    else
      session["devise.linkedin_uid"] = request.env["omniauth.auth"]
      redirect_to new_rep_dialer_registration_url
    end
  end
end