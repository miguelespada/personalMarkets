require 'spec_helper'

describe MapsController do

  let(:valid_session) { {} }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
