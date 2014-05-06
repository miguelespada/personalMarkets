class PaymillClientFactory

  def self.find_or_create_client email, name
    client = PaymillClient.find_by_email email
    if client.nil?
      client = Paymill::Client.create email: email, description: name
      PaymillClient.create!({email: email, client_id: client.id})
      client = PaymillClient.find_by_email email
    end
    client
  end
  
end