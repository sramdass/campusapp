# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :detail do
    email "MyString"
    secondary_email "MyString"
    phone "MyString"
    secondary_phone "MyString"
    address "MyString"
    dob "2012-01-02"
    memeber_id 1
    member_type "MyString"
  end
end
