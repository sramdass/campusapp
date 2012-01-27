# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grade do
    branch_id 1
    name "MyString"
    cut_off_percentage 1.5
    color_code "MyString"
  end
end
