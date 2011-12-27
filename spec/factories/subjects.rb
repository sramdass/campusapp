# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subject do
    name                  			"english"
    branch_id     					{Branch.first.id}
    year_id							{Year.find_by_current(true)}
  end
end
