FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:body) { |n| "description #{n}" }
    sequence(:body) { |n| "description #{n}" }
    sequence(:body) { |n| "description #{n}" }
  end
end
