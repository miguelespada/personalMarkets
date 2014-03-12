require 'spec_helper'

describe Market do
  it { should have_field :name }
  it { should have_field :description }

  describe "Elastic search" do
      it 'creates and destroys index' do
        FactoryGirl.create(:market)
        # Market.es.index.refresh
        # Market.es.index.exists?.should be_true
        # Market.es_index_name.should eq 'markets'
        # Market.es.index.delete
        # Market.es.index.exists?.should be_false
      end
      context 'search' do
        before :each do
          Market.es.index.delete
          @m1 = FactoryGirl.create(:market)
          @m2 = FactoryGirl.create(:market)
          @m3 = FactoryGirl.create(:market)
          @m1.update_attribute(:name, "Test")
          Market.es.index.refresh
        end 
        xit 'searches all models' do
            results = Market.es.search q: 'Market'
            results.count.should eq 3
            results.to_a.count.should eq 3
        end
        xit 'searches one model' do
            results = Market.es.search q: @m1.name
            results.count.should eq 1
            results.to_a.count.should eq 1
            results.first.id.should eq @m1.id
            results.first.user_id.should eq @m1.user_id
        end
      end
      context 'destroy' do
        before :each do
           # @markets = []
           # 10.times { @markets << FactoryGirl.create(:market)}
           # Market.es.index.refresh
        end
        xit 'destroy' do
          Market.es.all.count.should eq 10
          @markets[0].destroy
          Market.es.index.refresh
          Market.es.all.count.should eq 9
        end
        xit 'destroy all' do
          Market.es.all.count.should eq 10
          Market.destroy_all
          Market.es.index.refresh
          Market.es.all.count.should eq 0
        end
      end
  end
end