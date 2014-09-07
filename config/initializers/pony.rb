# ENV['GMAIL_SMTP_USER'] = "dowemarket@gmail.com"
# ENV['GMAIL_SMTP_PASSWORD'] = "A1m453S_X"

Pony.options = {
  :to => 'dowemarket@gmail.com',
  :via => :smtp,
  :via_options => {
    :address => 'smtp.gmail.com',
    :port => '587',
    :enable_starttls_auto => true,
    :user_name => ENV['GMAIL_SMTP_USER'],
    :password => ENV['GMAIL_SMTP_PASSWORD'],
    :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
}