class SecSubMap < ActiveRecord::Base
	belongs_to :section, :dependent => :destroy
	belongs_to :subject, :dependent => :destroy
	belongs_to :faculty	# no dependent destroy. When the faculty is removed we still want to know which subject goes to which section
end
