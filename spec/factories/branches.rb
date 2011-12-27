# Read about factories at http://github.com/thoughtbot/factory_girl


Factory.define :branch do |branch|
  branch.name 								"Jawahar"
  branch.address              				"3rd block, Neyveli-15"
  branch.resource_type_id     	5  
  branch.faculties {|faculties| [faculties.association(:faculty)]}
  branch.subjects {|subjects| [subjects.association(:subject)]}
  branch.clazzs {|clazzs| [clazzs.association(:clazz)]}    
end
