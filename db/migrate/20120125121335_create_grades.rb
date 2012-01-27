class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :branch_id
      t.string :name
      t.float :cut_off_percentage
      t.string :color_code

      t.timestamps
    end
  end
end
