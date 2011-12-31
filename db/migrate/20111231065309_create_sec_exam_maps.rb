class CreateSecExamMaps < ActiveRecord::Migration
  def change
    create_table :sec_exam_maps do |t|
      t.integer :section_id
      t.integer :exam_id
      t.date :startdate
      t.date :enddate
      t.integer :branch_id
      t.timestamps
    end
  end
end
