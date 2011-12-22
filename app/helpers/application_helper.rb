module ApplicationHelper
  #return the resource types for a particular object instance.
  #example, for an instance of Faculty, it will return teaching, non-teaching etc..
  def get_resource_types(obj)
    Resource.find_by_name(obj.class.to_s).resource_types
  end
end
