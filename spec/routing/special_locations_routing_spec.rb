require "spec_helper"

describe SpecialLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/special_locations").should route_to("special_locations#index")
    end

    it "routes to #new" do
      get("/special_locations/new").should route_to("special_locations#new")
    end

    it "routes to #show" do
      get("/special_locations/1").should route_to("special_locations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/special_locations/1/edit").should route_to("special_locations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/special_locations").should route_to("special_locations#create")
    end

    it "routes to #update" do
      put("/special_locations/1").should route_to("special_locations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/special_locations/1").should route_to("special_locations#destroy", :id => "1")
    end

  end
end
