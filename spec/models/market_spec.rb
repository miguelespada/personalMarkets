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
end