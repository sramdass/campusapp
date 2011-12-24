class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :login
      t.string :password_hash
      t.string :password_salt
      t.string :password_reset_token
      t.string :auth_token
      t.datetime :password_reset_sent_at
      t.string :user_type
      t.integer :user_id

      t.timestamps
    end
  end
end
