require 'spec_helper'

describe Market do
  it { should have_field :name }
  it { should have_field :description }

  describe "Search with no index" do
    it "creates an new index" do
      Market.delete_index
      expect{Market.search("", "")}.to change{Market.exists_index?}.from(false).to(true)
    end
  end 

  context "With no markets" do   
    describe "search" do
      it "returns an empty array" do
        Market.destroy_all
        expect(Market.search("", "")).to eq []
      end
    end
  end
  
  context "With markets" do
    before :each do
      @markets = []
      10.times { @markets << FactoryGirl.create(:market)}
      Market.refresh_index
    end   
    describe "search with blank query" do
      it "returns all the markets" do
        result = Market.search("", "")
        expect(result.count).to eq Market.all.count
      end
    end
  end
end