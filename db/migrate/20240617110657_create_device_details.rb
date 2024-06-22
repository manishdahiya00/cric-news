class CreateDeviceDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :device_details do |t|
      t.string :device_id
      t.string :device_type
      t.string :device_name
      t.string :advertising_id
      t.string :version_name
      t.string :version_code
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
      t.string :utm_content
      t.string :utm_term
      t.string :referrer_url
      t.string :user_id
      t.string :security_token

      t.timestamps
    end
  end
end
