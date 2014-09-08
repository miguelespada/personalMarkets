require 'spec_helper'

describe CategoriesController do

  let(:valid_session) { {} }
  let(:category) { build(:category) }
  let(:valid_attributes) { {name: "dummy category" }}
  let(:user) { create(:user) } 


  describe "GET 'gallery'" do
    it "returns http success" do
      category = Category.create! valid_attributes
      get 'gallery'
      response.should be_success
      assigns(:categories).should eq([category])
    end
  end

  describe "GET show" do
    it "redirects to categories path" do
      category = Category.create! valid_attributes
      get :show, {:id => category.to_param}, valid_session
      response.should redirect_to categories_path
    end
  end

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, Category
      controller.stub(:current_user).and_return(user)
    end
    
    describe "GET 'index'" do
      it "returns http success" do
        category = Category.create! valid_attributes
        get 'index'
        response.should be_success
        assigns(:categories).should eq([category])
      end
    end


    describe "GET new" do
      it "assigns a new category as @category" do
        get :new, {}, valid_session
        assigns(:category).should be_a_new(Category)
      end
    end
    
    describe "POST create" do
      let(:category_params) { { category_id: category.to_param, :category => category.attributes } } 
      
      describe "with valid params" do
        it "creates a new category" do
          expect {
            post :create, category_params, valid_session
            }.to change(Category, :count).by(1)
        end
      end

      it "has no markets" do
        post :create, category_params, valid_session
        assigns(:category).markets.should eq []
      end

      it "assigns a newly created category" do
        post :create, category_params, valid_session
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end

      it "redirects to the list of categories" do
        post :create, category_params, valid_session
        expect(response).to redirect_to categories_path
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved category as @category" do
          Category.any_instance.stub(:save).and_return(false)
          post :create, {:category => { "name" => "invalid value" }}, valid_session
          assigns(:category).should be_a_new(Category)
        end

        it "re-renders the 'new' template" do
          Category.any_instance.stub(:save).and_return(false)
          post :create, {:category => { "name" => "invalid value" }}, valid_session
        expect(response).to redirect_to categories_path
        end
      end
    end

    describe "DELETE category" do
      before :each do
       @category = FactoryGirl.create(:category)
      end
      
      it "removes the category" do
        expect {
          delete :destroy, { id: @category.to_param }, valid_session
          }.to change(Category, :count).by(-1)
      end

      it "redirects to the list of categories" do
        delete :destroy, { id: @category.to_param }, valid_session
        expect(response).to redirect_to categories_path
      end

      it "is not possible when it has markets" do
        FactoryGirl.create(:market, category: @category)
        expect {
        delete :destroy, { id: @category.to_param }, valid_session
        }.to change(Category, :count).by(0)
      end
    end
    
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested category" do
          category = Category.create! valid_attributes
          put :update, {:id => category.to_param, :category => { "name" => "MyString" }}, valid_session
          assigns(:category).name.should eq("MyString")
        end

        it "redirects to the category" do
          category = Category.create! valid_attributes
          put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
          response.should redirect_to(categories_path)
        end
      end

      describe "with invalid params" do
        it "assigns the category as @category" do
          category = Category.create! valid_attributes
          Category.any_instance.stub(:save).and_return(false)
          put :update, {:id => category.to_param, :category => { "name" => "invalid value" }}, valid_session
          assigns(:category).should eq(category)
        end

        it "re-renders the 'edit' template" do
          category = Category.create! valid_attributes
          Category.any_instance.stub(:save).and_return(false)
          put :update, {:id => category.to_param, :category => { "name" => "invalid value" }}, valid_session
          expect(response).to redirect_to categories_path
        end
      end

      describe "with invalid params" do
        it "assigns the category as @category" do
          category = Category.create! valid_attributes
          Category.any_instance.stub(:save).and_return(false)
          put :update, {:id => category.to_param, :category => { "description" => "invalid value" }}, valid_session
          assigns(:category).should eq(category)
        end

        it "re-renders the 'edit' template" do
          category = Category.create! valid_attributes
          Category.any_instance.stub(:save).and_return(false)
          put :update, {:id => category.to_param, :category => { "description" => "invalid value" }}, valid_session
          expect(response).to redirect_to categories_path
        end
      end
    end

  end

  context "unauthorized user" do
    let(:category_params) { { category_id: category.to_param, :category => category.attributes } } 
 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Category
      controller.stub(:current_user).and_return(user)
    end

    it "cannot edit" do
      category = Category.create! valid_attributes
      get :edit, {:id => category.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, category_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      category = Category.create! valid_attributes
      put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      category = Category.create! valid_attributes
      delete :destroy, {:id => category.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end
  
  context "guest user" do
    let(:category_params) { { category_id: category.to_param, :category => category.attributes } } 

    it "cannot edit" do
      category = Category.create! valid_attributes
      get :edit, {:id => category.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, category_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      category = Category.create! valid_attributes
      put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      category = Category.create! valid_attributes
      delete :destroy, {:id => category.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end
end