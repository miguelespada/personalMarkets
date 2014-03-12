require 'spec_helper'

describe Market do
  it { should have_field :name }
  it { should have_field :description }
end