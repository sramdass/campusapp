class CreateSecStudentMaps < ActiveRecord::Migration
  def change
    create_table :sec_student_maps do |t|
      t.integer :student_id
      t.integer :section_id

      t.timestamps
    end
  end
end
