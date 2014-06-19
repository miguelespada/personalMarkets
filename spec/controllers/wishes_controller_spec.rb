require 'spec_helper'

describe WishesController do

  let(:user) { create(:user) } 
  let(:other_user) { create(:user) } 
  let(:valid_attributes) { {description: "dummy wish", user: user} }

  let(:wish) {build(:wish)}
  let(:wish_params) { {:wish => wish.attributes } }

  let(:valid_session) { {} }

  describe "GET gallery" do
    it "assigns all wishes as @wishes" do
      wish = Wish.create! valid_attributes
      get :gallery, {}, valid_session
      assigns(:wishes).should eq([wish])
    end

  
    it "assigns all wishes as @wishes with 2 user wishes" do
      Wish.create! valid_attributes
      Wish.create!(description: "dummy wish", user: other_user)
      get :gallery, {}, valid_session
      assigns(:wishes).count.should eq 2
    end
  end

  describe "GET show" do
    it "show redirects to wishes_path " do
      wish = Wish.create! valid_attributes
      get :show, {id: wish.to_param}, valid_session 
      redirect_to wishes_path
    end

  end

  describe "GET list_user_wishes" do
     it "assigns user wishes as @wishes " do
      wish = Wish.create! valid_attributes
      Wish.create(description: "dummy wish", user: other_user)
      get :list_user_wishes, {user_id: user.to_param}, valid_session
      assigns(:wishes).should eq([wish])
    end

    it "assigns user wishes as @wishes with different user wishes" do
      Wish.create!(description: "dummy wish", user: user)
      Wish.create!(description: "dummy wish", user: other_user)
      get :list_user_wishes, {user_id: user.to_param}, valid_session
      assigns(:wishes).count.should eq 1
    end

    it "assigns the requested wish as @wish" do
      wish = Wish.create!(description: "dummy wish", user: user)
      get :list_user_wishes, { :user_id => user.to_param}, valid_session
      assigns(:wishes).should eq([wish])
    end
  end

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, Wish
      controller.stub(:current_user).and_return(user)
    end
    describe "GET index" do
      it "assigns all wishes as @wishes" do
        wish = Wish.create! valid_attributes
        get :index, {}, valid_session
        assigns(:wishes).should eq([wish])
      end
      it "assigns all wishes as @wishes with 2 user wishes" do
        Wish.create! valid_attributes
        Wish.create!(description: "dummy wish", user: other_user)
        get :index, {}, valid_session
        assigns(:wishes).count.should eq 2
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
        get :edit, {:id => wish.to_param}, valid_session
        assigns(:wish).should eq(wish)
        expect(response.response_code).to eq 200
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
          user.reload
          user.wishes.count.should eq 1 
        end

        it "success" do
          post :create, wish_params, valid_session
          response.should redirect_to user_wishes_path(user)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved wish as @wish" do
          Wish.any_instance.stub(:save).and_return(false)
          post :create, wish_params, valid_session
          assigns(:wish).should be_a_new(Wish)
        end

        it "re-renders the 'new' template" do
          Wish.any_instance.stub(:save).and_return(false)
          post :create, wish_params, valid_session
          response.should render_template("new")
        end
      end
    end
    describe "POST recommend" do

      describe "with valid market" do
        it "updates the recommendation list" do
          wish = Wish.create! valid_attributes
          market = create(:market)
          @request.env['HTTP_REFERER'] = '/'
          post :recommend, {:id => wish.to_param, :market => {:market_id => market.id}}, valid_session
          assigns(:wish).recommended.should eq([market])
          expect(response.response_code).to eq 200
        end
      end
    end 

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested wish" do
          wish = Wish.create! valid_attributes
          Wish.any_instance.should_receive(:update).with({ "description" => "MyString" })
          put :update, {:id => wish.to_param, :wish => { "description" => "MyString" }}, valid_session
        end

        it "assigns the requested wish as @wish" do
          wish = Wish.create! valid_attributes
          put :update, {:id => wish.to_param, :wish => valid_attributes}, valid_session
          assigns(:wish).should eq(wish)
        end

        it "redirects to the wish" do
          wish = Wish.create! valid_attributes
          put :update, {:id => wish.to_param, :wish => valid_attributes}, valid_session
          response.should redirect_to user_wishes_path(user)
        end
      end

      describe "with invalid params" do
        it "assigns the wish as @wish" do
          wish = Wish.create! valid_attributes
          Wish.any_instance.stub(:save).and_return(false)
          put :update, {:id => wish.to_param, :wish => { "description" => "invalid value" }}, valid_session
          assigns(:wish).should eq(wish)
        end

        it "re-renders the 'edit' template" do
          wish = Wish.create! valid_attributes
          Wish.any_instance.stub(:save).and_return(false)
          put :update, {:id => wish.to_param, :wish => { "description" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested wish" do
        wish = Wish.create! valid_attributes
        @request.env['HTTP_REFERER'] = '/'  
        expect {
          delete :destroy, {:id => wish.to_param}, valid_session
        }.to change(Wish, :count).by(-1)
      end

      it "redirects back" do
        wish = Wish.create! valid_attributes
        @request.env['HTTP_REFERER'] = '/'
        delete :destroy, {:id => wish.to_param}, valid_session
        expect(response.response_code).to eq 302
      end
    end
  end

  context "unauthorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Wish
      controller.stub(:current_user).and_return(user)
    end
    it "cannot edit" do
      wish = Wish.create! valid_attributes
      get :edit, {:id => wish.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, wish_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      wish = Wish.create! valid_attributes
      put :update, {:id => wish.to_param, :wish => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      wish = Wish.create! valid_attributes
      delete :destroy, {:id => wish.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end 

  context "guest user" do 
     it "cannot index all" do
      get :index, {}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot edit" do
      wish = Wish.create! valid_attributes
      get :edit, {:id => wish.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot create" do
      post :create, wish_params, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot update" do
      wish = Wish.create! valid_attributes
      put :update, {:id => wish.to_param, :wish => valid_attributes}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot delete" do
      wish = Wish.create! valid_attributes
      delete :destroy, {:id => wish.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end 
end
