require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:market) { FactoryGirl.create(:market, 
            :user => FactoryGirl.create(:user),
            :category => FactoryGirl.create(:category)) } 
  let(:user) { FactoryGirl.create(:user) } 

  describe "list" do
   it "renders the index template" do
      get :index, {user_id: user.to_param}, valid_session
      expect(response).to render_template("index")
    end
  end

  describe "Creating a new market" do
    it "assigns a new market" do
      get :new, {user_id: user.to_param}, valid_session
      expect(assigns(:market)).to be_a_new(Market)
    end
    context "with valid params" do
        it "creates a new Market" do
          expect {
            post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          }.to change(Market, :count).by(1)
        end
    end
    context "with valid params" do
        it "creates a new Market" do
          expect {
            post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          }.to change(Market, :count).by(1)
        end
    end
  end
  
    

end