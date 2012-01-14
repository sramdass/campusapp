# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mark_criteria do
    sec_test_map_id 1
    sec_sub_map_id 1
    max_marks 1.5
    pass_marks 1.5
  end
end
