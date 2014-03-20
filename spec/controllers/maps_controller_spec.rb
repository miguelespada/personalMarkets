require 'spec_helper'

describe MapsController do

  let(:valid_session) { {} }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it "no marker if no markets" do
      get 'index'
      expect(assigns(:geojson)).to eq ""
    end
  end
end
