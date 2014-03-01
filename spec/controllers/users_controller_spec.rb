require 'spec_helper'

describe UsersController do
	
  let(:valid_session) { {} }
 it "renders the index template" do
      get :index, valid_session
      expect(response).to render_template("index")
  end
end
