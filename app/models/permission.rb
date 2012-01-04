class Permission < ActiveRecord::Base
  belongs_to :resource, :dependent => :destroy
  belongs_to :role, :dependent => :destroy	
end
