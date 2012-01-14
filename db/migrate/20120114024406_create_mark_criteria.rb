class CreateMarkCriteria < ActiveRecord::Migration
  def change
    create_table :mark_criteria do |t|
      t.integer :sec_test_map_id
      t.integer :sec_sub_map_id
      t.float :max_marks
      t.float :pass_marks

      t.timestamps
    end
  end
end
