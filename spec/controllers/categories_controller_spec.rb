require 'spec_helper'

describe CategoriesController do

  let(:valid_session) { {} }
  let(:category) { FactoryGirl.build(:category) } 

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "Creating a category" do
    it "assigns a new category" do
      get :new, {}, valid_session
      expect(assigns(:category)).to be_a_new(Category)
    end

    context "with valid params" do
      let(:category_params) { { category_id: category.to_param, :category => category.attributes } } 

      it "creates a new category" do
      expect {
        post :create, category_params, valid_session
        }.to change(Category, :count).by(1)
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
    end
  end
  describe "Deleting category" do
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
  end
end