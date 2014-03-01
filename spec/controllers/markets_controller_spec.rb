require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) } 
  let(:market) { FactoryGirl.build(:market, 
            :user => FactoryGirl.create(:user),
            :category => FactoryGirl.create(:category)) } 

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
    
        it "assigns a newly created market" do
          post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          expect(assigns(:market)).to be_a(Market)
          expect(assigns(:market)).to be_persisted
        end

        it "redirects to the created market" do
          post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          expect(response).to redirect_to(user_market_path(user,Market.last))
        end
        describe "with invalid params" do
          before(:each) do
            Market.any_instance.stub(:save).and_return(false)
          end
          it "assigns a newly created but unsaved market" do
            post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
            expect(assigns(:market)).to be_a_new(Market)
          end
           it "re-renders the 'new' template" do
              post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
              expect(response).to render_template("new")
          end
      end
    end
  end
    describe "remove market" do
        before :each do
           @market = FactoryGirl.create(:market, 
                :user => FactoryGirl.create(:user),
                :category => FactoryGirl.create(:category))  
        end

      it "deletes market" do
          expect {
            delete :destroy, { id: @market.to_param, user_id: @market.user.id }, valid_session
          }.to change(Market, :count).by(-1)
      end
      it "redirects to contacts#index" do
          delete :destroy, id: @market
        response.should redirect_to user_path
      end
    end 
end