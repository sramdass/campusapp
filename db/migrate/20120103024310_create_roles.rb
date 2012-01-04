class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :branch_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
