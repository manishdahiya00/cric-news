class CreateNews < ActiveRecord::Migration[7.1]
  def change
    create_table :news do |t|
      t.string :name
      t.string :author
      t.string :image
      t.string :title
      t.text :description
      t.text :content
      t.string :url
      t.datetime :published_at

      t.timestamps
    end
  end
end
