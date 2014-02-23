require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }

  describe "Creating a new market" do
    it "assigns a new market" do
      get :new, {}, valid_session
      expect(assigns(:market)).to be_a_new(Market)
    end

      describe "with valid params" do
        it "creates a new Market" do
          expect {
            post :create, {:market => { "name" => "invalid value" }
              }, valid_session
          }.to change(Market, :count).by(1)
        end

        it "assigns a newly created market" do
          post :create, {:market => { "name" => "invalid value" }}, valid_session
          expect(assigns(:market)).to be_a(Market)
          expect(assigns(:market)).to be_persisted
        end

        it "redirects to the created market" do
          post :create, {:market => { "name" => "invalid value" }}, valid_session
          expect(response).to redirect_to(Market.last)
        end
      end

      describe "with invalid params" do
        before(:each) do
          Market.any_instance.stub(:save).and_return(false)
        end
        it "assigns a newly created but unsaved market" do
          post :create, {:market => { "name" => "invalid value" }}, valid_session
          expect(assigns(:market)).to be_a_new(Market)
        end

        it "re-renders the 'new' template" do
          post :create, {:market => { "name" => "invalid value" }}, valid_session
          expect(response).to render_template("new")
        end
      end
    end
end
