class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.string :address
      t.integer :resource_type_id

      t.timestamps
    end
  end
end
