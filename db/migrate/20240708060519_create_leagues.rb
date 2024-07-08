class CreateLeagues < ActiveRecord::Migration[7.1]
  def change
    create_table :leagues do |t|
      t.string :tournament_id
      t.string :tournament_name
      t.string :image

      t.timestamps
    end
  end
end
