ActionMailer::Base.smtp_settings = {
  :tls => "true", 
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "personas.ead.pucv.cl",
  :authentication => :plain,
  :user_name => "personas.ead",
  :password => "personas.asdwsx"
}