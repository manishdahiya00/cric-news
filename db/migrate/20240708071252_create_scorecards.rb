class CreateScorecards < ActiveRecord::Migration[7.1]
  def change
    create_table :scorecards do |t|
      t.string :mid
      t.string :teama_id
      t.string :teamb_id
      t.json :teama_innings
      t.json :teamb_innings

      t.timestamps
    end
  end
end
