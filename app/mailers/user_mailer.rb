class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  default from: "noreply@odinbook.com"

  def welcome_email
    @username = params[:username]
    mail(to: params[:email], subject: "Welcome to Odinbook")
  end
end
