class AddTotalToMarks < ActiveRecord::Migration
  def change
    add_column :marks, :total, :float
  end
end
