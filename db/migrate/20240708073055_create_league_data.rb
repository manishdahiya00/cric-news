class CreateLeagueData < ActiveRecord::Migration[7.1]
  def change
    create_table :league_data do |t|
      t.string :lid
      t.string :matchDate
      t.string :winning_team
      t.string :logo
      t.string :cid
      t.string :mid
      t.string :teama_id
      t.string :teama_name
      t.string :teama_abbr
      t.string :teama_logo
      t.string :teama_scores
      t.string :teama_overs
      t.string :teamb_id
      t.string :teamb_name
      t.string :teamb_abbr
      t.string :teamb_logo
      t.string :teamb_scores
      t.string :teamb_overs

      t.timestamps
    end
  end
end
