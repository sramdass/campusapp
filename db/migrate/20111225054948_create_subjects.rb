class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :branch_id
      t.integer :year_id

      t.timestamps
    end
  end
end
