class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.string :year
      t.boolean :current

      t.timestamps
    end
  end
end
