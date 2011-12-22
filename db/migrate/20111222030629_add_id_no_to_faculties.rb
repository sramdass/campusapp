class AddIdNoToFaculties < ActiveRecord::Migration
  def change
    add_column :faculties, :id_no, :string
  end
end
