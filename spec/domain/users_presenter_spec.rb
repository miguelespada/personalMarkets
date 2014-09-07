require 'users_presenter'

describe UsersPresenter do

  context 'getting the users grouped by role' do

    describe "#grouped_by_role" do
  
      it "yields the possible roles for a user" do
        expected_roles = ["admin", "normal"]
        presenter = UsersPresenter.for []
        
        presenter.grouped_by_role do |role, _|
          expected_roles.delete role
        end

        expect(expected_roles).to eql([])
      end

      it "yields users associated to statuses" do
        admins = [double("admin", role: "admin")]
        normals = [double("normal", role: "normal"), double("normal", role: "normal")]
        users = admins + normals
        presenter = UsersPresenter.for users

        yielded_users = {}
        presenter.grouped_by_role do |role, grouped_users|
          yielded_users[role] = grouped_users
        end

        expect(yielded_users["admin"]).to eql(admins)
        expect(yielded_users["normal"]).to eql(normals)
      end
  
    end

  end
  
end