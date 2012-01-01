# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    name "MyString"
    id_no "MyString"
    female false
    date_joined "2012-01-01"
    date_departed "2012-01-01"
    branch_id 1
    resource_type_id 1
  end
end
