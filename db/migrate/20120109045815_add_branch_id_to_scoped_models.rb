class AddBranchIdToScopedModels < ActiveRecord::Migration
  def change
    add_column :sec_student_maps, :branch_id, :integer
    add_column :permissions, :branch_id, :integer
    add_column :details, :branch_id, :integer
    add_column :role_memberships, :branch_id, :integer
  end
end
