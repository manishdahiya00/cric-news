namespace :fetchMatches do
  task upcomingMatches: :environment do
    begin
      require "rest-client"
      url = "https://rest.entitysport.com/v2/matches/?status=1&token=e9a8cd857f01e5f88127787d3931b63a"
      res = RestClient.get(url)
      response = JSON.parse(res)

      if response.dig("response", "items")
        response["response"]["items"].each do |match_data|
          next if match_data.nil?

          match = Match.find_by(mid: match_data["match_id"])

          unless match
            Match.create(
              status: "Upcoming",
              mid: match_data["match_id"],
              cid: match_data["competition"]["cid"],
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data.dig("teama", "name"),
              teama_logo: match_data.dig("teama", "logo_url"),
              teamb_name: match_data.dig("teamb", "name"),
              teamb_logo: match_data.dig("teamb", "logo_url"),
              venue_name: match_data.dig("venue", "name"),
              venue_location: match_data.dig("venue", "location"),
              venue_country: match_data.dig("venue", "country"),
              teama_scores_full: match_data.dig("teama", "scores_full") || "null",
              teama_scores: match_data.dig("teama", "scores") || "--",
              teama_overs: match_data.dig("teama", "overs") || "--",
              teamb_scores_full: match_data.dig("teamb", "scores_full") || "null",
              teamb_scores: match_data.dig("teamb", "scores") || "--",
              teamb_overs: match_data.dig("teamb", "overs") || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"],
            )
            puts "Created new match with ID: #{match_data["match_id"]}"
          else
            match.update(
              status: "Upcoming",
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data.dig("teama", "name"),
              teama_logo: match_data.dig("teama", "logo_url"),
              teamb_name: match_data.dig("teamb", "name"),
              teamb_logo: match_data.dig("teamb", "logo_url"),
              venue_name: match_data.dig("venue", "name"),
              venue_location: match_data.dig("venue", "location"),
              venue_country: match_data.dig("venue", "country"),
              teama_scores_full: match_data.dig("teama", "scores_full") || "null",
              teama_scores: match_data.dig("teama", "scores") || "--",
              teama_overs: match_data.dig("teama", "overs") || "--",
              teamb_scores_full: match_data.dig("teamb", "scores_full") || "null",
              teamb_scores: match_data.dig("teamb", "scores") || "--",
              teamb_overs: match_data.dig("teamb", "overs") || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"],
            )
            puts "Updated match with ID: #{match_data["match_id"]}"
          end
        end
      else
        puts "Invalid response format"
      end
    rescue Exception => e
      puts "API Exception - #{Time.now} - upcomingMatches - Error - #{e.message}"
    end
  end

  task liveMatches: :environment do
    begin
      require "rest-client"
      url = "https://rest.entitysport.com/v2/matches/?status=3&token=e9a8cd857f01e5f88127787d3931b63a"
      res = RestClient.get(url)
      response = JSON.parse(res)

      if response.dig("response", "items")
        response["response"]["items"].each do |match_data|
          next if match_data.nil?

          match = Match.find_by(mid: match_data["match_id"])

          unless match
            Match.create(
              status: "Live",
              mid: match_data["match_id"],
              cid: match_data["competition"]["cid"],
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data.dig("teama", "name"),
              teama_logo: match_data.dig("teama", "logo_url"),
              teamb_name: match_data.dig("teamb", "name"),
              teamb_logo: match_data.dig("teamb", "logo_url"),
              venue_name: match_data.dig("venue", "name"),
              venue_location: match_data.dig("venue", "location"),
              venue_country: match_data.dig("venue", "country"),
              teama_scores_full: match_data.dig("teama", "scores_full") || "null",
              teama_scores: match_data.dig("teama", "scores") || "--",
              teama_overs: match_data.dig("teama", "overs") || "--",
              teamb_scores_full: match_data.dig("teamb", "scores_full") || "null",
              teamb_scores: match_data.dig("teamb", "scores") || "--",
              teamb_overs: match_data.dig("teamb", "overs") || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"],
            )
            puts "Created new live match with ID: #{match_data["match_id"]}"
          else
            status = match.match_end_time && match.match_end_time < Time.now ? "Completed" : "Live"

            match.update(
              status: status,
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data.dig("teama", "name"),
              teama_logo: match_data.dig("teama", "logo_url"),
              teamb_name: match_data.dig("teamb", "name"),
              teamb_logo: match_data.dig("teamb", "logo_url"),
              venue_name: match_data.dig("venue", "name"),
              venue_location: match_data.dig("venue", "location"),
              venue_country: match_data.dig("venue", "country"),
              teama_scores_full: match_data.dig("teama", "scores_full") || "null",
              teama_scores: match_data.dig("teama", "scores") || "--",
              teama_overs: match_data.dig("teama", "overs") || "--",
              teamb_scores_full: match_data.dig("teamb", "scores_full") || "null",
              teamb_scores: match_data.dig("teamb", "scores") || "--",
              teamb_overs: match_data.dig("teamb", "overs") || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"],
            )
            puts "Updated live match with ID: #{match_data["match_id"]}"
          end
        end
      else
        puts "Invalid response format"
      end
    rescue Exception => e
      puts "API Exception - #{Time.now} - liveMatches - Error - #{e.message}"
    end
  end

  task completedMatches: :environment do
    begin
      require "rest-client"
      url = "https://rest.entitysport.com/v2/matches/?status=2&token=e9a8cd857f01e5f88127787d3931b63a"
      res = RestClient.get(url)
      response = JSON.parse(res)

      if response.dig("response", "items")
        response["response"]["items"].each do |match_data|
          next if match_data.nil?

          match = Match.find_by(mid: match_data["match_id"])

          unless match
            Match.create(
              status: "Completed",
              mid: match_data["match_id"],
              cid: match_data["competition"]["cid"],
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data.dig("teama", "name"),
              teama_logo: match_data.dig("teama", "logo_url"),
              teamb_name: match_data.dig("teamb", "name"),
              teamb_logo: match_data.dig("teamb", "logo_url"),
              venue_name: match_data.dig("venue", "name"),
              venue_location: match_data.dig("venue", "location"),
              venue_country: match_data.dig("venue", "country"),
              teama_scores_full: match_data.dig("teama", "scores_full") || "null",
              teama_scores: match_data.dig("teama", "scores") || "--",
              teama_overs: match_data.dig("teama", "overs") || "--",
              teamb_scores_full: match_data.dig("teamb", "scores_full") || "null",
              teamb_scores: match_data.dig("teamb", "scores") || "--",
              teamb_overs: match_data.dig("teamb", "overs") || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"],
            )
            puts "Created new completed match with ID: #{match_data["match_id"]}"
          else
            match.update(
              status: "Completed",
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data.dig("teama", "name"),
              teama_logo: match_data.dig("teama", "logo_url"),
              teamb_name: match_data.dig("teamb", "name"),
              teamb_logo: match_data.dig("teamb", "logo_url"),
              venue_name: match_data.dig("venue", "name"),
              venue_location: match_data.dig("venue", "location"),
              venue_country: match_data.dig("venue", "country"),
              teama_scores_full: match_data.dig("teama", "scores_full") || "null",
              teama_scores: match_data.dig("teama", "scores") || "--",
              teama_overs: match_data.dig("teama", "overs") || "--",
              teamb_scores_full: match_data.dig("teamb", "scores_full") || "null",
              teamb_scores: match_data.dig("teamb", "scores") || "--",
              teamb_overs: match_data.dig("teamb", "overs") || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"],
            )
            puts "Updated completed match with ID: #{match_data["match_id"]}"
          end
        end
      else
        puts "Invalid response format"
      end
    rescue Exception => e
      puts "API Exception - #{Time.now} - completedMatches - Error - #{e.message}"
    end
  end

  task updateMatches: :environment do
    begin
      matches = Match.all

      matches.each do |match|
        next if match.nil?

        date_start = match.match_time
        date_end = match.match_end_time

        status = if date_end && date_end < Time.now
            "Completed"
          elsif date_start && date_start > Time.now
            "Upcoming"
          else
            "Live"
          end

        match.update(
          status: status,
          title: match.title,
          short_title: match.short_title,
          match_type: match.match_type,
          teama_name: match.teama_name,
          teama_logo: match.teama_logo,
          teamb_name: match.teamb_name,
          teamb_logo: match.teamb_logo,
          venue_name: match.venue_name,
          venue_location: match.venue_location,
          venue_country: match.venue_country,
          teama_scores_full: match.teama_scores_full || "null",
          teama_scores: match.teama_scores || "--",
          teama_overs: match.teama_overs || "--",
          teamb_scores_full: match.teamb_scores_full || "null",
          teamb_scores: match.teamb_scores || "--",
          teamb_overs: match.teamb_overs || "--",
          match_time: date_start,
          match_end_time: date_end,
        )

        puts "Updated match with ID: #{match.id} - Status: #{status}"
      end
    rescue StandardError => e
      puts "API Exception - #{Time.now} - updateMatches - Error - #{e.message}"
    end
  end
end
