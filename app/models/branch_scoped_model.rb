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
  default_scope lambda { where('branch_id = ?', Branch.current) }
  before_save { self.branch_id = Branch.current }	
end
