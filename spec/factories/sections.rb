# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section do
    name "MyString"
    faculty_id 1
    clazz_id 1
    branch_id 1
  end
end
