class RenameProfileIdToUserProfileId < ActiveRecord::Migration
  def up
  	rename_column :role_memberships, :profile_id, :user_profile_id
  end

  def down
  end
end
