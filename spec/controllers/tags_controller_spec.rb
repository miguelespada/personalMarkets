require 'spec_helper'

describe TagsController do

  let(:valid_session) { {} }
  let(:tag) { build(:tag) }
  let(:valid_attributes) { {name: "dummy tag" }}
  let(:user) { create(:user) } 

  describe "GET 'suggested'" do
    it "returns http success" do
      tag = Tag.create! valid_attributes
      get 'suggested', {format: 'json'}
      assigns(:suggested).should eq([tag.name])
      response.should be_success
    end
  end

  describe "GET 'gallery'" do
    it "returns http success" do
      tag = Tag.create! valid_attributes
      get 'gallery'
      response.should be_success
      assigns(:suggested).should eq([tag])
    end
  end

  describe "GET show" do
    it "redirects to the list of markets belonging to the tag" do
      tag = Tag.create! valid_attributes
      get :show, {:id => tag.to_param}, valid_session
      response.should redirect_to tags_path
    end
  end

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, Tag
      controller.stub(:current_user).and_return(user)
    end
    describe "GET 'index'" do

      it "returns http success assigns admin suggested tags" do
        tag = Tag.create! valid_attributes
        get 'index'
        assigns(:tags).should eq([tag])
        assigns(:user_tags).should eq("")
        response.should be_success
      end

      it "returns http success assigns market tags" do
        create(:market, :tags => "dummy1,dummy2")
        create(:market, :tags => "dummy2")
        get 'index'
        response.should be_success
        assigns(:user_tags).should eq("dummy1,dummy2")
        assigns(:tags).should eq([])
      end
    end

    describe "GET new" do
      it "assigns a new tag as @tag" do
        get :new, {}, valid_session
        assigns(:tag).should be_a_new(Tag)
      end
    end
    
    describe "POST create" do
      let(:tag_params) { { tag_id: tag.to_param, :tag => tag.attributes } } 
      
      describe "with valid params" do
        it "creates a new tag" do
          expect {
            post :create, tag_params, valid_session
            }.to change(Tag, :count).by(1)
        end
      end

      it "assigns a newly created tag" do
        post :create, tag_params, valid_session
        expect(assigns(:tag)).to be_a(Tag)
        expect(assigns(:tag)).to be_persisted
      end

      it "redirects to the list of tags" do
        post :create, tag_params, valid_session
        expect(response).to redirect_to tags_path
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved tag as @tag" do
          Tag.any_instance.stub(:save).and_return(false)
          post :create, {:tag => { "name" => "invalid value" }}, valid_session
          assigns(:tag).should be_a_new(Tag)
        end

        it "re-renders the 'new' template" do
          Tag.any_instance.stub(:save).and_return(false)
          post :create, {:tag => { "name" => "invalid value" }}, valid_session
          response.should redirect_to(tags_path)
        end
      end
    end

    describe "DELETE tag" do
      before :each do
       @tag = FactoryGirl.create(:tag)
      end
      
      it "removes the tag" do
        expect {
          delete :destroy, { id: @tag.to_param }, valid_session
          }.to change(Tag, :count).by(-1)
      end

      it "redirects to the list of tags" do
        delete :destroy, { id: @tag.to_param }, valid_session
        expect(response).to redirect_to tags_path
      end
    end
    
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested tag" do
          tag = Tag.create! valid_attributes
          put :update, {:id => tag.to_param, :tag => { "name" => "MyString" }}, valid_session
          assigns(:tag).name.should eq("MyString")
        end

        it "redirects to the tag" do
          tag = Tag.create! valid_attributes
          put :update, {:id => tag.to_param, :tag => valid_attributes}, valid_session
          response.should redirect_to(tags_path)
        end
      end

      describe "with invalid params" do
        it "assigns the tag as @tag" do
          tag = Tag.create! valid_attributes
          Tag.any_instance.stub(:save).and_return(false)
          put :update, {:id => tag.to_param, :tag => { "name" => "invalid value" }}, valid_session
          assigns(:tag).should eq(tag)
        end

        it "re-renders the 'edit' template" do
          tag = Tag.create! valid_attributes
          Tag.any_instance.stub(:save).and_return(false)
          put :update, {:id => tag.to_param, :tag => { "name" => "invalid value" }}, valid_session
          response.should redirect_to(tags_path)
        end
      end

      describe "with invalid params" do
        it "assigns the tag as @tag" do
          tag = Tag.create! valid_attributes
          Tag.any_instance.stub(:save).and_return(false)
          put :update, {:id => tag.to_param, :tag => { "description" => "invalid value" }}, valid_session
          assigns(:tag).should eq(tag)
        end

        it "re-renders the 'edit' template" do
          tag = Tag.create! valid_attributes
          Tag.any_instance.stub(:save).and_return(false)
          put :update, {:id => tag.to_param, :tag => { "description" => "invalid value" }}, valid_session
          response.should redirect_to(tags_path)
        end
      end
    end

  end

  context "unauthorized user" do
    let(:tag_params) { { tag_id: tag.to_param, :tag => tag.attributes } } 
 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Tag
      controller.stub(:current_user).and_return(user)
    end

    it "cannot edit" do
      tag = Tag.create! valid_attributes
      get :edit, {:id => tag.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, tag_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      tag = Tag.create! valid_attributes
      put :update, {:id => tag.to_param, :tag => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      tag = Tag.create! valid_attributes
      delete :destroy, {:id => tag.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end
  
  context "guest user" do
    let(:tag_params) { { tag_id: tag.to_param, :tag => tag.attributes } } 

    it "cannot edit" do
      tag = Tag.create! valid_attributes
      get :edit, {:id => tag.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, tag_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      tag = Tag.create! valid_attributes
      put :update, {:id => tag.to_param, :tag => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      tag = Tag.create! valid_attributes
      delete :destroy, {:id => tag.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end
end