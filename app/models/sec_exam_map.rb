class SecExamMap < ActiveRecord::Base
  belongs_to :section, :dependent => :destroy
  belongs_to :exam, :dependent => :destroy
end
