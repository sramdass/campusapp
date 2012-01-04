# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    resource_id 1
    resource_action_id 1
    privilege 1
    constraints 1
  end
end
