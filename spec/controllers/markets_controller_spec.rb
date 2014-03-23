require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) } 
  let(:market) { FactoryGirl.build(:market)}
  let(:market_params) { { user_id: user.to_param, :market => market.attributes } }

  describe "Creating a new market" do

    it "assigns a new market" do
      get :new, {user_id: user.to_param}, valid_session
      expect(assigns(:market)).to be_a_new(Market)
    end

    context "with valid parameters" do
      it "assigns a newly created market" do
        post :create, market_params, valid_session
        expect(assigns(:market)).to be_a(Market)
        expect(assigns(:market)).to be_persisted
      end

      it "creates a new Market" do
        expect {
          post :create, market_params, valid_session
          }.to change(Market, :count).by(1)
      end

      it "redirects to the created market" do
        post :create, market_params, valid_session
        created_market_path = user_market_path(user, Market.last)
        expect(response).to redirect_to(created_market_path)
      end
        
      describe "with invalid params" do

        before(:each) do
          Market.any_instance.stub(:save).and_return(false)
        end

        it "assigns a newly created but unsaved market" do
          post :create, market_params, valid_session
          expect(assigns(:market)).to be_a_new(Market)
        end

        it "re-renders the 'new' template" do
          post :create, market_params, valid_session
          expect(response).to render_template("new")
        end
      end
    end
  end
end