require 'spec_helper'
describe PhotosController do

  let(:photo) { create(:photo) } 
  let(:valid_attributes) { {id: photo.to_param, x: "80", y: "200", w: "300", h: "400"}}
  let(:valid_session) { {} }
  let(:user) { create(:user) } 

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, Photo
      controller.stub(:current_user).and_return(user)
    end
    describe "Post /crop" do
      it "it adds crop metadata" do
        post :crop,  valid_attributes, valid_session
        assigns(:photo).crop.should_not be_nil
        expect(response.response_code).to eq 302
      end
    end
    describe "DELETE destroy" do
      it "destroys the requested photo" do
        photo = Photo.create!
        @request.env['HTTP_REFERER'] = '/'
        expect {
          delete :destroy, {:id => photo.to_param}, valid_session
        }.to change(Photo, :count).by(-1)
      end
    end
    describe "index" do
      it "it is allowed" do
        get :index, {}, valid_session
        expect(response.response_code).to eq 200
      end

      it "does not show empty photos" do
        Photo.new
        get :index, {}, valid_session
        assigns(:photos).count.should eq 0
      end

      it "list photos with attachment" do
        create(:photo)
        get :index, {}, valid_session
        assigns(:photos).count.should eq 1
      end
    end
    describe "list user photos" do

      it "it is allowed" do
        get :list_user_photos, {user_id: user.to_param}, valid_session
        expect(response.response_code).to eq 200
      end

      it "does not show empty photos" do
        Photo.new
        get :list_user_photos, {:user_id: user.to_param}, valid_session
        assigns(:photos).count.should eq 0
      end

      it "list photos with attachment" do
        create(:photo)
        get :list_user_photos, {user_id: user.to_param}, valid_session
        assigns(:photos).count.should eq 1
      end
    end
  end

  context "unauthorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Photo
      controller.stub(:current_user).and_return(user)
    end
    describe "Post /crop" do
      it "it adds crop metadata" do
        post :crop,  valid_attributes, valid_session
        expect(response.response_code).to eq 403
      end

      it "cannot delete" do
        delete :destroy, {:id => photo.to_param}, valid_session
        expect(response.response_code).to eq 403
      end
    end
  end

end