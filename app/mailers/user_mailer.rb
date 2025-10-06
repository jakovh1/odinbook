class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  default from: "jakovh97@gmail.com"

  def welcome_email
    @username = params[:username]
    mail(to: params[:email], subject: "Welcome to Odinbook")
  end
end
