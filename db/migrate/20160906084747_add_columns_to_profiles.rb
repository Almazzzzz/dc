class AddColumnsToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :show_email, :boolean
    add_column :profiles, :show_phone, :boolean
  end
end
