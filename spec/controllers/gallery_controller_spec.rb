require 'spec_helper'

describe GalleryController do
  let(:gallery) { create(:gallery) } 
  let(:valid_session) { {} }
  describe "GET show" do
    it "assigns all wishes as @wishes" do
      get :show, {id: gallery.to_param}, valid_session
      expect(response.response_code).to eq 302
    end
  end
end