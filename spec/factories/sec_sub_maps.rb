# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sec_sub_maps do
    section_id 1
    subject_id 1
    faculty_id 1
    mark_column "MyString"
  end
end
