class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :id
      t.string :name
      t.boolean :female
      t.date :date_joined
      t.date :date_departed
      t.integer :branch_id
      t.integer :resource_type_id
      t.timestamps
    end
  end
end
