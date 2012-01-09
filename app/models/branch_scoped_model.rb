class BranchScopedModel < ActiveRecord::Base
  self.abstract_class = true

  class << self
    protected
      def current_scoped_methods
        last = scoped_methods.last
        last.respond_to?(:call) ? relation.scoping { last.call } : last
      end      
  end

  belongs_to :branch
  validates_presence_of :branch
  #This default scope creates problem with has_many :through relations.
  #So, we only update the branch_id when the records are saved and then do the authorizatoin
  #(whether the user accesses only his branch's records) using cancan.
  
  #default_scope lambda { where('branch_id = ?', Branch.current) }
  before_validation { self.branch_id = Branch.current }	
  
  #With before_save we cannot validate the presence of branch.
  #before_save { self.branch_id = 1 }	
end
