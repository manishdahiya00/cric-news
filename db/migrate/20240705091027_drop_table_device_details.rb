class DropTableDeviceDetails < ActiveRecord::Migration[7.1]
  def change
    drop_table :device_details
  end
end
