require 'spec_helper'

describe User do

  let(:user) { create(:user) }
  let(:premium) { create(:user, :premium) }
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

    it "has a published market then it can create a VIM market" do
      @market = create(:market)
      user.markets << @market
      @market.publish
      expect(user.markets.count).to eq 1
      expect(user.create_new_vim_market.name).to eq "New VIM market"
    end

    it "knows the most recent market" do
      @market_new = create(:market, :publish_date => 1.week.ago)
      @market_old = create(:market, :publish_date => 3.weeks.ago)

      user.markets << create(:market)
      user.markets << @market_new
      user.markets << @market_old
      user.markets << create(:market)
      
      expect(user.most_recent_market(1)).to eq @market_new
      expect(user.most_recent_market(2)).to eq @market_old
      expect(user.most_recent_market(3)).to eq nil
    end

    it "has a published market then he has to wait" do
      @market_new = create(:market, :publish_date => 1.weeks.ago)
      user.markets << @market_new
      expect(user.days_until_can_create_new_market).to eq 24
    end

    it "user is pro does not have to wait" do
      premium.markets << create(:market, :publish_date => 1.week.ago)
      expect(premium.days_until_can_create_new_market).to eq 0
    end

    it "user is pro has to wait when has severa markets" do
      premium.markets << create(:market, :publish_date => 3.days.ago)
      premium.markets << create(:market, :publish_date => 1.week.ago)
      premium.markets << create(:market, :publish_date => 2.weeks.ago)
      premium.markets << create(:market, :publish_date => 3.weeks.ago)
      expect(premium.days_until_can_create_new_market).to eq 10
    end
    it "tracks the number of market drafts" do
      user.markets << create(:market, :publish_date => 3.days.ago)
      user.markets << create(:market)
      user.markets << create(:market, :publish_date => 1.week.ago)
      user.markets << create(:market)
      user.markets << create(:market, :publish_date => 2.weeks.ago)
      user.markets << create(:market, :publish_date => 3.weeks.ago)
      expect(user.number_of_drafts).to eq 2
    end
  end
end