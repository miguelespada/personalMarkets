require 'spec_helper'

describe MapsController do

  let(:valid_session) { {} }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', valid_session
      response.should be_success
    end
    it "no marker if no markets" do
      get 'index', valid_session
      expect(assigns(:geojson)).to eq ""
    end
    it "marker without location" do
      FactoryGirl.create(:market)
      get 'index', valid_session
      expect(assigns(:geojson)).to eq ""
    end

    it "marker empty location" do
      FactoryGirl.create(:market, :latitude => "", :longitude => "")
      get 'index', valid_session
      expect(assigns(:geojson)).to eq ""
    end

    it "marker with location" do
      FactoryGirl.create(:market, :latitude => "40", :longitude => "-3")
      get 'index', valid_session
      expect(assigns(:geojson)).not_to eq ""
    end
  end
end
