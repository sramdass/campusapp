class AddResourceIdToResourceActions < ActiveRecord::Migration
  def change
    add_column :resource_actions, :resource_id, :integer
  end
end
