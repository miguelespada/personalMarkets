Pony.options = {
  :to => 'p3rs0n4l.m4rk3ts@gmail.com',
  :via => :smtp,
  :via_options => {
    :address => 'smtp.gmail.com',
    :port => '587',
    :enable_starttls_auto => true,
    :user_name => 'p3rs0n4l.m4rk3ts',
    :password => 'magdalenasfederico',
    :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
}