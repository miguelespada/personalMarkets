require 'spec_helper'

describe SpecialLocationsController do

  let(:valid_attributes) { {name: "dummy_location", latitude: 0, longitude: 0 }}
  let(:valid_session) { {} }
  let(:admin) { create(:user, :admin) } 
  let(:user) { create(:user) } 
  let(:special_location) { build(:special_location) }

  describe "GET index" do
    it "assigns all special_locations as @special_locations" do
      special_location = SpecialLocation.create! valid_attributes
      get :index, {}, valid_session
      assigns(:special_locations).should eq([special_location])
    end
  end

  describe "GET gallery" do
    it "assigns all special_locations as @special_locations" do
      special_location = SpecialLocation.create! valid_attributes
      get :index, {}, valid_session
      assigns(:special_locations).should eq([special_location])
    end
  end

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, SpecialLocation
      controller.stub(:current_user).and_return(user)
    end

    describe "GET new" do
      it "assigns a new special_location as @special_location" do
        get :new, {}, valid_session
        assigns(:special_location).should be_a_new(SpecialLocation)
      end
    end

    describe "GET edit" do
      it "assigns the requested special_location as @special_location" do
        special_location = SpecialLocation.create! valid_attributes
        get :edit, {:id => special_location.to_param}, valid_session
        assigns(:special_location).should eq(special_location)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new SpecialLocation" do
          expect {
            post :create, {:special_location => valid_attributes}, valid_session
          }.to change(SpecialLocation, :count).by(1)
        end


        it "assigns a newly created special_location as @special_location" do
          post :create, {:special_location => valid_attributes}, valid_session
          assigns(:special_location).should be_a(SpecialLocation)
          assigns(:special_location).should be_persisted
        end

        it "redirects to the created special_location" do
          post :create, {:special_location => valid_attributes}, valid_session
          response.should redirect_to(special_locations_path)
        end
        
        it "create with image" do
          all = {"utf8"=>"✓", "authenticity_token"=>"6FM3P0RTHmee1nFsDn0wFIoq/c62Xmz1vb20n0yFtkY=", "special_location"=>{"name"=>"malasaña", "address"=>"malasaña", "city"=>"Madrid, España", "latitude"=>"40.380267", "longitude"=>"-3.621229699999999", "photography_attributes"=>{"photo"=>"[{\"public_id\":\"eofjihx0ofdhymtnqspr\",\"version\":1399647194,\"signature\":\"317e0eb32cf48fe799d0a1449b1452e661e344c2\",\"width\":1000,\"height\":620,\"format\":\"jpg\",\"resource_type\":\"image\",\"created_at\":\"2014-05-09T14:53:14Z\",\"tags\":[\"attachinary_tmp\",\"development_env\"],\"bytes\":100065,\"type\":\"upload\",\"etag\":\"32ca41239ec02186a800426632c2d1b8\",\"url\":\"http://res.cloudinary.com/espadaysantacruz/image/upload/v1399647194/eofjihx0ofdhymtnqspr.jpg\",\"secure_url\":\"https://res.cloudinary.com/espadaysantacruz/image/upload/v1399647194/eofjihx0ofdhymtnqspr.jpg\"}]"}}, "commit"=>"Create Special location"}
          post :create, all, valid_session
          assigns(:special_location).photo.should_not be_nil
          assigns(:special_location).photo.should be_persisted
          Photo.all.count.should be 1
        end 
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved special_location as @special_location" do
          SpecialLocation.any_instance.stub(:save).and_return(false)
          post :create, {:special_location => { "name" => "invalid value" }}, valid_session
          assigns(:special_location).should be_a_new(SpecialLocation)
        end

        it "re-renders the 'new' template" do
          SpecialLocation.any_instance.stub(:save).and_return(false)
          post :create, {:special_location => { "name" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested special_location" do
          special_location = SpecialLocation.create! valid_attributes
          SpecialLocation.any_instance.should_receive(:update).with({ "name" => "MyString" })
          put :update, {:id => special_location.to_param, :special_location => { "name" => "MyString" }}, valid_session
        end

        it "assigns the requested special_location as @special_location" do
          special_location = SpecialLocation.create! valid_attributes
          put :update, {:id => special_location.to_param, :special_location => valid_attributes}, valid_session
          assigns(:special_location).should eq(special_location)
        end

        it "redirects to the special_location" do
          special_location = SpecialLocation.create! valid_attributes
          put :update, {:id => special_location.to_param, :special_location => valid_attributes}, valid_session
          response.should redirect_to(special_locations_path)
        end
      end

      describe "with invalid params" do
        it "assigns the special_location as @special_location" do
          special_location = SpecialLocation.create! valid_attributes
          SpecialLocation.any_instance.stub(:save).and_return(false)
          put :update, {:id => special_location.to_param, :special_location => { "name" => "invalid value" }}, valid_session
          assigns(:special_location).should eq(special_location)
        end

        it "re-renders the 'edit' template" do
          special_location = SpecialLocation.create! valid_attributes
          SpecialLocation.any_instance.stub(:save).and_return(false)
          put :update, {:id => special_location.to_param, :special_location => { "name" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested special_location" do
        special_location = SpecialLocation.create! valid_attributes
        expect {
          delete :destroy, {:id => special_location.to_param}, valid_session
        }.to change(SpecialLocation, :count).by(-1)
      end

      it "redirects to the special_locations list" do
        special_location = SpecialLocation.create! valid_attributes
        delete :destroy, {:id => special_location.to_param}, valid_session
        response.should redirect_to(special_locations_url)
      end
    end
  end

  context "unauthorized user" do
    let(:special_location_params) { { special_location_id: special_location.to_param, :special_location => special_location.attributes } } 
 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, SpecialLocation
      controller.stub(:current_user).and_return(user)
    end

    it "cannot edit" do
      special_location = SpecialLocation.create! valid_attributes
      get :edit, {:id => special_location.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, special_location_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      special_location = SpecialLocation.create! valid_attributes
      put :update, {:id => special_location.to_param, :special_location => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      special_location = SpecialLocation.create! valid_attributes
      delete :destroy, {:id => special_location.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end
  
  context "guest user" do
    let(:special_location_params) { { special_location_id: special_location.to_param, :special_location => special_location.attributes } } 

    it "cannot edit" do
      special_location = SpecialLocation.create! valid_attributes
      get :edit, {:id => special_location.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, special_location_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      special_location = SpecialLocation.create! valid_attributes
      put :update, {:id => special_location.to_param, :special_location => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      special_location = SpecialLocation.create! valid_attributes
      delete :destroy, {:id => special_location.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end
end
