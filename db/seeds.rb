# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["Branch", "Faculty", "Clazz", "Subject", "Test", "Student"].each do |res|
  Resource.find_or_create_by_name res
end

res = Resource.find_by_name!("Branch")
["School", "Engineering College"].each do |res_type|
  ResourceType.find_or_create_by_name_and_resource_id(:name => res_type, :resource_id => res.id)
end

res = Resource.find_by_name!("Faculty")
["Teaching", "Non Teaching"].each do |res_type|
  ResourceType.find_or_create_by_name_and_resource_id(:name => res_type, :resource_id => res.id)
end

if !Branch.first
  Branch.create!(name: "Jawahar", address: "Neyveli-15", resource_type_id: 1)
end