require 'spec_helper'
describe PhotosController do

  let(:photo) { create(:photo) } 
  let(:valid_attributes) { {id: photo.to_param, x: "80", y: "200", w: "300", h: "400"}}
  let(:valid_session) { {} }


  describe "Post /crop" do
    it "it adds crop metadata" do
      post :crop,  valid_attributes, valid_session
      assigns(:photo).crop.should_not be_nil
    end
  end
end