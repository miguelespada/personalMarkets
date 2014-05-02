require 'spec_helper'

describe BargainsController do

  let(:user) { create(:user) } 
  let(:other_user) { create(:user) } 
  let(:valid_attributes) { {description: "dummy bargain", user: user} }

  let(:bargain) {build(:bargain)}
  let(:bargain_params) { {:bargain => bargain.attributes } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all bargains as @bargains" do
      bargain = Bargain.create! valid_attributes
      get :index, {}, valid_session
      assigns(:bargains).should eq([bargain])
    end

    it "assigns user bargains as @bargains " do
      bargain = Bargain.create! valid_attributes
      get :list_user_bargains, {user_id: user.to_param}, valid_session
      assigns(:bargains).should eq([bargain])
    end

    it "assigns all bargains as @bargains with 2 user bargains" do
      Bargain.create! valid_attributes
      Bargain.create!(description: "dummy bargain", user: other_user)
      get :index, {}, valid_session
      assigns(:bargains).count.should eq 2
    end

    it "assigns user bargains as @bargains with different user bargains" do
      Bargain.create!(description: "dummy bargain", user: user)
      Bargain.create!(description: "dummy bargain", user: other_user)
      get :list_user_bargains, {user_id: user.to_param}, valid_session
      assigns(:bargains).count.should eq 1
    end
  end

  describe "GET show" do
    it "assigns the requested bargain as @bargain" do
      bargain = Bargain.create! valid_attributes
      get :show, {:id => bargain.to_param}, valid_session
      assigns(:bargain).should eq(bargain)
    end
  end

  describe "GET list_user_bargains" do
    it "assigns the requested bargain as @bargain" do
      bargain = Bargain.create!(description: "dummy bargain", user: user)
      get :list_user_bargains, { :user_id => user.to_param}, valid_session
      assigns(:bargains).should eq([bargain])
    end
  end

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, Bargain
      controller.stub(:current_user).and_return(user)
    end

    describe "GET new" do
      it "assigns a new bargain as @bargain" do
        get :new, {:user_id => user.to_param}, valid_session
        assigns(:bargain).should be_a_new(Bargain)
      end
    end

    describe "GET edit" do
      it "assigns the requested bargain as @bargain" do
        bargain = Bargain.create! valid_attributes
        get :edit, {:id => bargain.to_param}, valid_session
        assigns(:bargain).should eq(bargain)
        expect(response.response_code).to eq 200
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Bargain" do
          expect {
            post :create, bargain_params, valid_session
          }.to change(Bargain, :count).by(1)
        end

        it "assigns a newly created bargain as @bargain" do
          post :create, bargain_params, valid_session
          assigns(:bargain).should be_a(Bargain)
          assigns(:bargain).should be_persisted
        end

        it "increments user bargains count" do
          user.bargains.count.should eq 0
          post :create, bargain_params, valid_session
          user.reload
          user.bargains.count.should eq 1 
        end

        it "success" do
          post :create, bargain_params, valid_session
          expect(response).to redirect_to Bargain.last
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved bargain as @bargain" do
          Bargain.any_instance.stub(:save).and_return(false)
          post :create, bargain_params, valid_session
          assigns(:bargain).should be_a_new(Bargain)
        end

        it "re-renders the 'new' template" do
          Bargain.any_instance.stub(:save).and_return(false)
          post :create, bargain_params, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested bargain" do
          bargain = Bargain.create! valid_attributes
          Bargain.any_instance.should_receive(:update).with({ "description" => "MyString" })
          put :update, {:id => bargain.to_param, :bargain => { "description" => "MyString" }}, valid_session
        end

        it "assigns the requested bargain as @bargain" do
          bargain = Bargain.create! valid_attributes
          put :update, {:id => bargain.to_param, :bargain => valid_attributes}, valid_session
          assigns(:bargain).should eq(bargain)
        end

        it "redirects to the bargain" do
          bargain = Bargain.create! valid_attributes
          put :update, {:id => bargain.to_param, :bargain => valid_attributes}, valid_session
          response.should redirect_to bargain
        end
      end

      describe "with invalid params" do
        it "assigns the bargain as @bargain" do
          bargain = Bargain.create! valid_attributes
          Bargain.any_instance.stub(:save).and_return(false)
          put :update, {:id => bargain.to_param, :bargain => { "description" => "invalid value" }}, valid_session
          assigns(:bargain).should eq(bargain)
        end

        it "re-renders the 'edit' template" do
          bargain = Bargain.create! valid_attributes
          Bargain.any_instance.stub(:save).and_return(false)
          put :update, {:id => bargain.to_param, :bargain => { "description" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested bargain" do
        bargain = Bargain.create! valid_attributes
        expect {
          delete :destroy, {:id => bargain.to_param}, valid_session
        }.to change(Bargain, :count).by(-1)
      end

      it "redirects to the bargains list" do
        bargain = Bargain.create! valid_attributes
        delete :destroy, {:id => bargain.to_param}, valid_session
        response.should redirect_to user_bargains_path(user)
      end
    end
  end

  context "unauthorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Bargain
      controller.stub(:current_user).and_return(user)
    end
    it "cannot edit" do
      bargain = Bargain.create! valid_attributes
      get :edit, {:id => bargain.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, bargain_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      bargain = Bargain.create! valid_attributes
      put :update, {:id => bargain.to_param, :bargain => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      bargain = Bargain.create! valid_attributes
      delete :destroy, {:id => bargain.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end 

  context "guest user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Bargain
    end
    
    it "cannot edit" do
      bargain = Bargain.create! valid_attributes
      get :edit, {:id => bargain.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, bargain_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      bargain = Bargain.create! valid_attributes
      put :update, {:id => bargain.to_param, :bargain => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      bargain = Bargain.create! valid_attributes
      delete :destroy, {:id => bargain.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end 
end
