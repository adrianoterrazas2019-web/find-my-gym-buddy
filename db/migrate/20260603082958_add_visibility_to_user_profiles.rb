class AddVisibilityToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :show_name, :boolean, default: true, null: false
    add_column :user_profiles, :show_gender, :boolean, default: true, null: false
  end
end
