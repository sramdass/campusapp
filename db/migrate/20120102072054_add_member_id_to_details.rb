class AddMemberIdToDetails < ActiveRecord::Migration
  def change
    add_column :details, :member_id, :integer
    remove_column :details, :memeber_id
  end
end
