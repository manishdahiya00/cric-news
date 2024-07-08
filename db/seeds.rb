require "rest-client"
leagues_res = RestClient.get("https://rest.entitysport.com/v4/tournaments?token=e9a8cd857f01e5f88127787d3931b63a")
leagues_data = JSON.parse(leagues_res)
leagues_data["response"]["items"].each do |league|
  if league.present? && league["tournament_id"].present? && league["name"].present?
    image = ImagesHelper.search_league_image(league["name"])[2]
    existing_league = League.find_by(tournament_id: league["tournament_id"].to_s)
    unless existing_league.present?
      League.create(
        tournament_id: league["tournament_id"],
        tournament_name: league["name"],
        image: image,
      )
    end
  else
    puts "Skipping invalid league: #{league.inspect}"
  end
end
