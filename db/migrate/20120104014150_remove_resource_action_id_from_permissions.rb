class RemoveResourceActionIdFromPermissions < ActiveRecord::Migration
  def up
    remove_column :permissions, :resource_action_id  	
  end

  def down
  end
end
