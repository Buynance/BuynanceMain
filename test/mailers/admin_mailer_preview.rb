class AdminMailerPreview < ActionMailer::Preview

  def qualified_signup
  	AdminMailer.qualified_signup(Business.last.id)
  end
end