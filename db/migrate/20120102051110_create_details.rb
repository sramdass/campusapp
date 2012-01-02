class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :email
      t.string :secondary_email
      t.string :phone
      t.string :secondary_phone
      t.string :address
      t.date :dob
      t.integer :memeber_id
      t.string :member_type

      t.timestamps
    end
  end
end
