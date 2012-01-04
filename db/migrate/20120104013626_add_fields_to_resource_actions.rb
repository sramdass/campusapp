class AddFieldsToResourceActions < ActiveRecord::Migration
  def change
    add_column :resource_actions, :code, :integer
    add_column :resource_actions, :description, :string
  end
end
