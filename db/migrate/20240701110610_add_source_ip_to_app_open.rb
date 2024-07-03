class AddSourceIpToAppOpen < ActiveRecord::Migration[7.1]
  def change
    add_column :app_opens, :source_ip, :string
  end
end
