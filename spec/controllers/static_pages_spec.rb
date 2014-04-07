require 'spec_helper'

describe StaticPagesController do

  let(:valid_session) { {} }

  describe "GET 'map'" do
    it "returns http success" do
      get 'map', valid_session
      response.should be_success
    end

    it "shows no markers if there are no markets" do
      get 'map', valid_session
      expect(assigns(:geojson)).to eq ""
    end
    
    it "dos not show markers without location" do
      create(:market)
      get 'map', valid_session
      expect(assigns(:geojson)).to eq ""
    end

    it "does not show markers empty location" do
      create(:market, :latitude => "", :longitude => "")
      get 'map', valid_session
      expect(assigns(:geojson)).to eq ""
    end

    it "shows marker with location" do
      create(:market, :latitude => "40", :longitude => "-3")
      get 'map', valid_session
      expect(assigns(:geojson)).not_to eq ""
    end
  end
end
