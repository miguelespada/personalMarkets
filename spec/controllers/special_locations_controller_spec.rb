require 'spec_helper'

describe SpecialLocationsController do

  let(:valid_attributes) { {name: "dummy_location", latitude: 0, longitude: 0 }}
  let(:valid_session) { {} }
  let(:admin) { create(:user, :admin) } 

  describe "GET index" do
    it "assigns all special_locations as @special_locations" do
      special_location = SpecialLocation.create! valid_attributes
      get :index, {}, valid_session
      assigns(:special_locations).should eq([special_location])
    end
  end

  describe "GET show" do
    it "assigns the requested special_location as @special_location" do
      special_location = SpecialLocation.create! valid_attributes
      get :show, {:id => special_location.to_param}, valid_session
      assigns(:special_location).should eq(special_location)
    end
  end

  describe "GET new" do
    it "assigns a new special_location as @special_location" do
      sign_in :user, admin
      get :new, {}, valid_session
      assigns(:special_location).should be_a_new(SpecialLocation)
    end
  end

  describe "GET edit" do
    it "assigns the requested special_location as @special_location" do
      sign_in :user, admin
      special_location = SpecialLocation.create! valid_attributes
      get :edit, {:id => special_location.to_param}, valid_session
      assigns(:special_location).should eq(special_location)
    end
  end

  describe "POST create" do
    before(:each) do
      sign_in :user, admin
    end
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
        response.should redirect_to(SpecialLocation.last)
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
    before(:each) do
      sign_in :user, admin
    end
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
        response.should redirect_to(special_location)
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
    before(:each) do
      sign_in :user, admin
    end
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
