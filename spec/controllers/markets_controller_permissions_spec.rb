require 'spec_helper'

describe MarketsController do


  let(:valid_session) { {} }
  let(:user) { create(:user) } 
  let(:market) { create(:market) }

  let(:market_params) { { user_id: user.to_param, 
                  id: market.to_param } }

  describe "unauthorized user" do 

    it "cannot index all" do
      get :index, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 403
    end


    [:slideshow, :list_published_markets, :list_last_markets, 
      :list_user_markets, :list_liked_markets, :search].each do |get_action|
      it "can #{get_action}" do
        get get_action, { user_id: user.to_param }, valid_session
        expect(response.response_code).to eq 200
      end
    end
    
    it "can list by tag" do
      get :list_tag_markets, { user_id: user.to_param, tag: "dummy" }, valid_session
      expect(response.response_code).to eq 200
    end

    it "can list by category" do
      category = create(:category)
      get :list_category_markets, { user_id: user.to_param, category_id: category.to_param}, valid_session
      expect(response.response_code).to eq 200
    end

    it "cannot create" do
      post :create, market_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot destroy" do
      delete :destroy, market_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot destroy" do
      delete :destroy, market_params, valid_session
      expect(response.response_code).to eq 403
    end

    [:archive, :publish, :publish_anyway, :make_pro, :unpublish].each do |post_action|
      it "forbidden #{post_action}" do
        post post_action, { market_id: market.to_param }, valid_session
        expect(response.response_code).to eq 403
      end
    end
  end 


end
