class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
  def linkedin
    auth = env["omniauth.auth"]
    @rep_dialer = nil

    if session[:family_signup] == "true"
      @rep_dialer = RepDialer.connect_to_linkedin(request.env["omniauth.auth"],current_rep_dialer_friends, "family")
      session[:family_signup] = nil
    else
      @rep_dialer = RepDialer.connect_to_linkedin(request.env["omniauth.auth"],current_rep_dialer_friends)
    end

    if @rep_dialer.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in @rep_dialer, :event => :authentication
      if @rep_dialer.role = "family"
        redirect_to dialer_account_family_dashboards_path
      else
        redirect_to dialer_account_dialer_dashboards_path
      end
    else
      session["devise.linkedin_uid"] = request.env["omniauth.auth"]
      redirect_to new_rep_dialer_registration_url
    end
  end
end