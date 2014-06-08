require 'spec_helper'

describe StaticPagesController do

  let(:valid_session) { {} }

  describe "GET 'map'" do
    it "returns http success" do
      get 'map', valid_session
      response.should be_success
    end

    xit "shows no markers if there are no markets" do
      get 'map', valid_session
      expect(assigns(:geojson)).to eq ""
    end
    
    xit "dos not show markers without location" do
      create(:market)
      get 'map', valid_session
      expect(assigns(:geojson)).to eq ""
    end

    xit "does not show markers empty location" do
      create(:market, :latitude => "", :longitude => "")
      get 'map', valid_session
      expect(assigns(:geojson)).to eq ""
    end

    xit "shows marker with location" do
      create(:market, :latitude => "40", :longitude => "-3")
      get 'map', valid_session
      expect(assigns(:geojson)).not_to eq ""
    end
  end
end
