# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_profile do
    login "MyString"
    password_hash "MyString"
    password_salt "MyString"
    password_reset_token "MyString"
    auth_token "MyString"
    password_reset_sent_at "2011-12-24 10:27:13"
    user_type "MyString"
    user_id 1
  end
end
