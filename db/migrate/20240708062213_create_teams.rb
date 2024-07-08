class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :mid
      t.string :match_type
      t.string :teama_name
      t.string :teama_abbr
      t.string :teama_url
      t.string :teama_scores
      t.string :teamb_name
      t.string :teamb_abbr
      t.string :teamb_url
      t.string :teamb_scores
      t.json :teama
      t.json :teamb

      t.timestamps
    end
  end
end
