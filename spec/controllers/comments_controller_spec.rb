require 'spec_helper'

describe CommentsController do

  let(:valid_session) { {} }
  let(:moderator) { create(:user, :moderator) } 
  let(:admin) { create(:user, :admin) } 
  let(:user) { create(:user) } 

  describe "Permissions" do

    context "Destroy" do

      let(:market) { create(:market) }
      let(:comment) { create(:comment, market: market) } 

      it "allowed for moderator" do
        sign_in :user, moderator
        market.comments << comment

        post :destroy, { market_id: market.id, id: comment.id }, valid_session
      end

      it "allowed for admin" do
        sign_in :user, admin
        market.comments << comment

        post :destroy, { market_id: market.id, id: comment.id }, valid_session
      end

      it "not allowed to regular user when is not the author" do
        sign_in :user, user
        market.comments << comment

        post :destroy, { market_id: market.id, id: comment.id }, valid_session
        expect(response.response_code).to eq 401
      end

      it "allowed to regular user when is the author" do
        sign_in :user, user
        comment.author = user.email
        market.comments << comment

        post :destroy, { market_id: market.id, id: comment.id }, valid_session
      end
    end

    context "Update" do
      it "not allowed for moderator" do
        sign_in :user, moderator
        market = create(:market, user: user)
        comment = create(:comment, market: market)
        market.comments << comment

        post :update, { market_id: market.id, id: comment.id }, valid_session
        expect(response.response_code).to eq 401
      end

      it "allowed for admin" do
        sign_in :user, admin
        market = create(:market, user: user)
        comment = create(:comment, market: market)
        market.comments << comment

        post :update, { market_id: market.id, id: comment.id }, valid_session
      end

      it "not allowed for regular user when is not the author" do
        sign_in :user, user
        market = create(:market, user: user)
        comment = create(:comment, market: market)
        market.comments << comment

        post :update, { market_id: market.id, id: comment.id }, valid_session
        expect(response.response_code).to eq 401
      end

      it "allowed for regular user when is the author" do
        sign_in :user, user
        market = create(:market, user: user)
        comment = create(:comment, market: market)
        comment.author = user.email
        market.comments << comment

        post :update, { market_id: market.id, id: comment.id }, valid_session
      end
    end
  end

end