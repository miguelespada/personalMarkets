require 'spec_helper'

describe User do

  let(:user) { create(:user) }
  it { should have_field :nickname }
  it { should have_field :description }


  describe "Roles" do
    it "default user is normal" do
      expect(user.has_role?(:admin)).to eq false
      expect(user.has_role?(:premium)).to eq false
      expect(user.has_role?(:normal)).to eq true
    end
    
    it "can create markets" do
      expect(user.allowed_market_creation?).to eq true
    end

    it "has a published market then it cannot create another one" do
      @market = create(:market)
      user.markets << @market
      @market.publish
      expect(user.allowed_market_creation?).to eq false
    end

    it "has a published market then it can create a VIM market" 

    it "knows the most recent market" do


      @market_old = create(:market, :publish_date => 3.weeks.ago)
      @market_new = create(:market, :publish_date => 1.weeks.ago)

      user.markets << create(:market)
      user.markets <<  @market_new
      user.markets <<  @market_old
      user.markets << create(:market)
      
      expect(user.most_recent_market).to eq @market_new
    end

    
    it "has a published market then he has to wait" do
      @market = create(:market)
      user.markets << @market
      @market.publish
      @market.publish_date = 1.week.ago
      @market.save
      expect(user.days_until_can_create_new_market).to eq 23
    end

  end
end