# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :market do
    sequence(:name) { |n| "My market #{n}" }
    sequence(:description) { |n| "My market description #{n}" }
    user
    category
  end
  
  factory :market_with_photo, class: Market do
    name "My personal market"
    description "My market description"
    featured '[{"public_id":"dummy",
            "version":1,
            "signature":"dummy",
            "width":75,
            "height":75,
            "format":"png",
            "resource_type":"image",
            "created_at":"dummy_data",
            "tags":["attachinary_tmp","development_env"],
            "bytes":0,
            "type":"upload",
            "etag":"dummy_etag",
            "url":"http://dummy.png",
            "secure_url":"http://dummy.png"}]'
  end
  
end
