class ChangeAttrOfTables < ActiveRecord::Migration[7.1]
  def change
    rename_column :app_opens, :device_id, :user_id
  end
end
