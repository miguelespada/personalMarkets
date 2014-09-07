module UserElasticsearch
  extend ActiveSupport::Concern

  module ClassMethods

    def reindex
       delete_index
       index_all
    end

    def exists_index?
      Tire.index('users').exists?
    end

    def delete_index
       Tire.index('users').delete
    end

    def refresh_index
       Tire.index('users').refresh
    end

    def create_index
       Tire.index 'users' do
          delete
          create :mappings => {
            :user => {
              :properties => {
                  :nickname => {type: :string, :analyzer => :snowball, :boost => 50},
                  :description => {type: :string, :analyzer => :snowball, :boost => 30}
              }
            }
          }
    end
  end


    def index_all
      unless Tire.index('users').exists?
        create_index
        Tire.index 'users' do
            import User.all
            refresh
        end
      end
    end
  end

end
