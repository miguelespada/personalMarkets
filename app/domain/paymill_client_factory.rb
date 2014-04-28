class PaymillClientFactory

  def find_or_create_client email
    client = PaymillClient.find_by_email email
    if client.nil?
      client = Paymill::Client.create email: email, description: subscription_params["name"]
      PaymillClient.create!({email: email, client_id: client.id})
      client = PaymillClient.find_by_email email
    end
    client
  end
  
end