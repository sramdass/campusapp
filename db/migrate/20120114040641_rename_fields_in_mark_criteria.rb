class RenameFieldsInMarkCriteria < ActiveRecord::Migration
  def up
    rename_column :mark_criteria, :sec_sub_map_id, :subject_id
    rename_column :mark_criteria, :sec_exam_map_id, :exam_id
    add_column :mark_criteria, :section_id, :integer
  end

  def down
  end
end
