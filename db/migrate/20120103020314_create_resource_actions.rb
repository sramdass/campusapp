class CreateResourceActions < ActiveRecord::Migration
  def change
    create_table :resource_actions do |t|
      t.string :name

      t.timestamps
    end
  end
end
