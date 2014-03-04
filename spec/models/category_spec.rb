require 'spec_helper'

describe Category do
  it { should have_field :name }

  it 'Uncategorized is the default category' do
  	pending "Check is the best way to create de default 'Uncategorized' record?"
  	Category.where(name: "Uncategorized").count.should eq 1
  end

end