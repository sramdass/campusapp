class AddBranchIdToMarkCriterias < ActiveRecord::Migration
  def change
    add_column :mark_criteria, :branch_id, :integer
  end
end
