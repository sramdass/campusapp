class AddBloodGroupToDetails < ActiveRecord::Migration
  def change
    add_column :details, :blood_group_id, :integer
  end
end
