class CreateAppOpens < ActiveRecord::Migration[7.1]
  def change
    create_table :app_opens do |t|
      t.string :device_id
      t.string :version_name
      t.string :version_code
      t.string :security_token
      t.string :app_url
      t.string :social_name
      t.string :social_img_url
      t.string :social_email
      t.string :force_update, default: "false"

      t.timestamps
    end
  end
end
