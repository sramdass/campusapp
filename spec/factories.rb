FactoryGirl.define do
  factory :branch do
    name                  			"Jawahar"
    address              			"3rd block, Neyveli-15"
    resource_type_id     	2
  end
  
  factory :faculty do
  	branch
  	#the above is equivalent to association :branch, :factory => :branch, :method => :build
  	name							"Satheesh"
  	id_no							"12345"
  	female						false
  	date_joined				{Date.today-5}
  	date_departed			{Date.today-3}
  	resource_type_id		4
  	branch_id					{Branch.first.id}
  end
end