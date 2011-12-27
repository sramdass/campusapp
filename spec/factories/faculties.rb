# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :faculty do
  	#the above is equivalent to association :branch, :factory => :branch, :method => :build
  	name							"Satheesh"
  	id_no							"1"
  	female						false
  	date_joined				{Date.today-5}
  	date_departed			{Date.today-3}
  	resource_type_id		4
  	branch_id					{Branch.first.id}
  end
end
