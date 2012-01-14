class RenameSecTestMapIdInMarkCriterias < ActiveRecord::Migration
  def up
    rename_column :mark_criteria, :sec_test_map_id, :sec_exam_map_id
  end

  def down
  end
end
