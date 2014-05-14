require 'spec_helper'

describe MarketsController do
  let(:user) { create(:user) }  
  let(:valid_session) { {} }
  let(:market) {create(:market)}

  xit "needs to be redefined"
  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, Market
      controller.stub(:current_user).and_return(user)
    end

    describe "GET new" do
      it "assigns a new wish as @market" do
        get :new, {:user_id => user.to_param}, valid_session
        assigns(:market).should be_a_new(Market)
        assigns(:market).coupon.should be_a_new(Coupon)
        assigns(:market).coupon.photography.should be_a_new(Photo)
        assigns(:market).featured.should be_a_new(Photo)
        assigns(:market).gallery.should be_a_new(Gallery)
        assigns(:market).gallery.photographies.length.should eq 3
      end
    end
  end
end