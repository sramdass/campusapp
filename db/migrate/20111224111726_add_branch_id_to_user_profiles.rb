class AddBranchIdToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :branch_id, :integer
  end
end
