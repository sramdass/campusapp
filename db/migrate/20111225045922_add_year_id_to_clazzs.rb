class AddYearIdToClazzs < ActiveRecord::Migration
  def change
    add_column :clazzs, :year_id, :integer
  end
end
