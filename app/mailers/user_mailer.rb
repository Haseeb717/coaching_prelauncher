class UserMailer < ActionMailer::Base
  default from: "Harry's <welcome@localhoops.com>"

  def signup_email(user)
    @user = user
    @twitter_message = "#Shaving is evolving. Excited for @localhoops to launch."
    byebug
    mail(:to => user.email, :subject => "Thanks for signing up!")
  end
end
