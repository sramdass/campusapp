class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :id_no
      t.boolean :female
      t.date :date_joined
      t.date :date_departed
      t.integer :branch_id
      t.integer :resource_type_id

      t.timestamps
    end
  end
end
