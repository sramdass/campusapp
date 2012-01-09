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
  #This default scope creates problem when the hirerachies are more than 1.
  #For example, the db says that the branch_id is ambiguous when referring the exams of a particular section.
  #Also there is a problem when querying from the rails console as there are not current profile.
  #We need to see if his can be restricted with cancan authorization.
  
  #default_scope lambda { where('branch_id = ?', Branch.current) }
  default_scope lambda { where('branch_id = ?', 1) }
  #before_save { self.branch_id = Branch.current }	
  before_save { self.branch_id = 1 }	
end
