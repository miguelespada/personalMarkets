module Elasticsearch
  extend ActiveSupport::Concern

  module ClassMethods
    def find_all(user = nil)
      if user
        user.markets.all
      else
        Market.all
      end
    end

    def reindex
       delete_index
       index_all
    end

    def exists_index?
      Tire.index('markets').exists?
    end

    def delete_index
       Tire.index('markets').delete
    end

    def refresh_index
       Tire.index('markets').refresh
    end

    def create_index
       Tire.index 'markets' do
          delete
          create mappings: {
            market: {
              properties: {
                  category: { type: 'string', analyzer: 'keyword' }
              }
            }
          }
        end 
    end

    def index_all
      unless Tire.index('markets').exists?
        create_index
        Tire.index 'markets' do
            import Market.all
            refresh
          end 
        end
    end


  end
  
end
