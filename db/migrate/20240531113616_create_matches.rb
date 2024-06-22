class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string :mid
      t.string :cid
      t.string :title
      t.string :status
      t.string :short_title
      t.string :match_type
      t.string :teama_name
      t.string :teama_logo
      t.string :teamb_name
      t.string :teamb_logo
      t.string :venue_name
      t.string :venue_location
      t.string :venue_country
      t.string :teama_scores_full
      t.string :teama_scores
      t.string :teama_overs
      t.string :teamb_scores_full
      t.string :teamb_scores
      t.string :teamb_overs
      t.string :match_time
      t.string :match_end_time

      t.timestamps
    end
  end
end
