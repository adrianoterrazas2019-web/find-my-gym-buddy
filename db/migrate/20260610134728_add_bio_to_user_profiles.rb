class AddBioToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :bio, :text
  end
end
