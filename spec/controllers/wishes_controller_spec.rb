require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe WishesController do

  # This should return the minimal set of attributes required to create a valid
  # Wish. As you add validations to Wish, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:user) } 
  let(:other_user) { create(:user) } 
  let(:valid_attributes) { {description: "dummy wish", user: user} }

  let(:wish) {build(:wish)}
  let(:wish_params) { { :user_id => user.to_param, 
                  :wish => wish.attributes } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WishesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all wishes as @wishes" do
      wish = Wish.create! valid_attributes
      get :index, {}, valid_session
      assigns(:wishes).should eq([wish])
    end
    it "assigns user wishes as @wishes " do
      wish = Wish.create! valid_attributes
      get :index, {user_id: user.to_param}, valid_session
      assigns(:wishes).should eq([wish])
    end

    it "assigns all wishes as @wishes with 2 user wishes" do
      Wish.create! valid_attributes
      Wish.create!(description: "dummy wish", user: other_user)
      get :index, {}, valid_session
      assigns(:wishes).count.should eq 2
    end

    it "assigns user wishes as @wishes with different user wishes" do
      Wish.create!(description: "dummy wish", user: user)
      Wish.create!(description: "dummy wish", user: other_user)
      get :index, {user_id: user.to_param}, valid_session
      assigns(:wishes).count.should eq 1
    end

  end

  describe "GET show" do
    it "assigns the requested wish as @wish" do
      wish = Wish.create! valid_attributes
      get :show, {user_id: user.to_param, :id => wish.to_param}, valid_session
      assigns(:wish).should eq(wish)
    end
  end

  describe "GET new" do
    it "assigns a new wish as @wish" do
      get :new, {:user_id => user.to_param}, valid_session
      assigns(:wish).should be_a_new(Wish)
    end
  end

  describe "GET edit" do
    it "assigns the requested wish as @wish" do
      wish = Wish.create! valid_attributes
      get :edit, {:id => wish.to_param, :user_id => user.to_param}, valid_session
      assigns(:wish).should eq(wish)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Wish" do
        expect {
          post :create, wish_params, valid_session
        }.to change(Wish, :count).by(1)
      end

      it "assigns a newly created wish as @wish" do
        post :create, wish_params, valid_session
        assigns(:wish).should be_a(Wish)
        assigns(:wish).should be_persisted
      end

      it "increments user wishes count" do
        user.wishes.count.should eq 0
        post :create, wish_params, valid_session
        assigns(:user).wishes.count.should eq 1 
      end

      it "success" do
        post :create, wish_params, valid_session
        expect(response).to redirect_to user_wishes_path(Wish.last.user, Wish.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved wish as @wish" do
        # Trigger the behavior that occurs when invalid params are submitted
        Wish.any_instance.stub(:save).and_return(false)
        post :create, wish_params, valid_session
        assigns(:wish).should be_a_new(Wish)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Wish.any_instance.stub(:save).and_return(false)
        post :create, wish_params, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested wish" do
        wish = Wish.create! valid_attributes
        # Assuming there are no other wishes in the database, this
        # specifies that the Wish created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Wish.any_instance.should_receive(:update).with({ "description" => "MyString" })
        put :update, {:user_id => user.to_param, :id => wish.to_param, :wish => { "description" => "MyString" }}, valid_session
      end

      it "assigns the requested wish as @wish" do
        wish = Wish.create! valid_attributes
        put :update, {:user_id => user.to_param, :id => wish.to_param, :wish => valid_attributes}, valid_session
        assigns(:wish).should eq(wish)
      end

      it "redirects to the wish" do
        wish = Wish.create! valid_attributes
        put :update, {:user_id => user.to_param, :id => wish.to_param, :wish => valid_attributes}, valid_session
        response.should redirect_to user_wish_path(user, wish)
      end
    end

    describe "with invalid params" do
      it "assigns the wish as @wish" do
        wish = Wish.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Wish.any_instance.stub(:save).and_return(false)
        put :update, {:user_id => user.to_param, :id => wish.to_param, :wish => { "description" => "invalid value" }}, valid_session
        assigns(:wish).should eq(wish)
      end

      it "re-renders the 'edit' template" do
        wish = Wish.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Wish.any_instance.stub(:save).and_return(false)
        put :update, {:user_id => user.to_param, :id => wish.to_param, :wish => { "description" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested wish" do
      wish = Wish.create! valid_attributes
      expect {
        delete :destroy, {:user_id => user.to_param, :id => wish.to_param}, valid_session
      }.to change(Wish, :count).by(-1)
    end

    it "redirects to the wishes list" do
      wish = Wish.create! valid_attributes
      delete :destroy, {:user_id => user.to_param, :id => wish.to_param}, valid_session
      response.should redirect_to user_wishes_path(user)
    end
  end

end
