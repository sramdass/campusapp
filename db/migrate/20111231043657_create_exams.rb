class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :name
      t.integer :branch_id
      t.integer :year_id

      t.timestamps
    end
  end
end
