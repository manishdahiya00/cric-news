namespace :fetchMatches do
  task upcomingMatches: :environment do
    begin
      require "rest-client"
      url = "https://rest.entitysport.com/v2/matches/?status=1&token=e9a8cd857f01e5f88127787d3931b63a"
      res = RestClient.get(url)
      response = JSON.parse(res)
      if response["response"] && response["response"]["items"]
        response["response"]["items"].each do |match_data|
          next if match_data.nil?
          match = Match.find_by(mid: match_data["match_id"])
          unless match.present?
            Match.create(
              status: "Upcoming",
              mid: match_data["match_id"],
              cid: match_data["competition"]["cid"],
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data["teama"]["name"],
              teama_logo: match_data["teama"]["logo_url"],
              teamb_name: match_data["teamb"]["name"],
              teamb_logo: match_data["teamb"]["logo_url"],
              venue_name: match_data["venue"]["name"],
              venue_location: match_data["venue"]["location"],
              venue_country: match_data["venue"]["country"],
              teama_scores_full: match_data["teama"]["scores_full"] || "null",
              teama_scores: match_data["teama"]["scores"] || "--",
              teama_overs: match_data["teama"]["overs"] || "--",
              teamb_scores_full: match_data["teamb"]["scores_full"] || "null",
              teamb_scores: match_data["teamb"]["scores"] || "--",
              teamb_overs: match_data["teamb"]["overs"] || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"]
            )
            puts "Hello from matchId: #{match_data["match_id"]}"
          else
            if match.match_end_time < Time.now && match.match_start_time > Time.now
              status =  "Live"
              else
                status = "Upcoming"
              end
            match.update(
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data["teama"]["name"],
              teama_logo: match_data["teama"]["logo_url"],
              teamb_name: match_data["teamb"]["name"],
              teamb_logo: match_data["teamb"]["logo_url"],
              venue_name: match_data["venue"]["name"],
              venue_location: match_data["venue"]["location"],
              venue_country: match_data["venue"]["country"],
              match_time: match_data["date_start"]
            )
            puts "Hello from updated matchId: #{match_data["match_id"]}"
          end
        end
      else
        puts "Invalid response format"
      end
    rescue Exception => e
      puts "API Exception-#{Time.now}-create-matches-Error-#{e}"
    end
  end
  task liveMatches: :environment do
    begin
      require "rest-client"
      url = "https://rest.entitysport.com/v2/matches/?status=3&token=e9a8cd857f01e5f88127787d3931b63a"
      res = RestClient.get(url)
      response = JSON.parse(res)
      if response["response"] && response["response"]["items"]
        response["response"]["items"].each do |match_data|
          next if match_data.nil?
          match = Match.find_by(mid: match_data["match_id"])
          unless match.present?
            Match.create(
              status: "Live",
              mid: match_data["match_id"],
              cid: match_data["competition"]["cid"],
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data["teama"]["name"],
              teama_logo: match_data["teama"]["logo_url"],
              teamb_name: match_data["teamb"]["name"],
              teamb_logo: match_data["teamb"]["logo_url"],
              venue_name: match_data["venue"]["name"],
              venue_location: match_data["venue"]["location"],
              venue_country: match_data["venue"]["country"],
              teama_scores_full: match_data["teama"]["scores_full"] || "null",
              teama_scores: match_data["teama"]["scores"] || "--",
              teama_overs: match_data["teama"]["overs"] || "--",
              teamb_scores_full: match_data["teamb"]["scores_full"] || "null",
              teamb_scores: match_data["teamb"]["scores"] || "--",
              teamb_overs: match_data["teamb"]["overs"] || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"]
            )
            puts "Hello from matchId: #{match_data["match_id"]}"
          else
              if match.match_end_time < Time.now
              status =  "Completed"
              else
                status = "Live"
              end
            match.update(
              status: status,
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data["teama"]["name"],
              teama_logo: match_data["teama"]["logo_url"],
              teamb_name: match_data["teamb"]["name"],
              teamb_logo: match_data["teamb"]["logo_url"],
              venue_name: match_data["venue"]["name"],
              venue_location: match_data["venue"]["location"],
              venue_country: match_data["venue"]["country"],
              teama_scores_full: match_data["teama"]["scores_full"] || "null",
              teama_scores: match_data["teama"]["scores"] || "--",
              teama_overs: match_data["teama"]["overs"] || "--",
              teamb_scores_full: match_data["teamb"]["scores_full"] || "null",
              teamb_scores: match_data["teamb"]["scores"] || "--",
              teamb_overs: match_data["teamb"]["overs"] || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"]
            )
            puts "Hello from updated matchId: #{match_data["match_id"]}"
          end
        end
      else
        puts "Invalid response format"
      end
    rescue Exception => e
      puts "API Exception-#{Time.now}-create-matches-Error-#{e}"
    end
  end
  task completedMatches: :environment do
    begin
      require "rest-client"
      url = "https://rest.entitysport.com/v2/matches/?status=2&token=e9a8cd857f01e5f88127787d3931b63a"
      res = RestClient.get(url)
      response = JSON.parse(res)
      if response["response"] && response["response"]["items"]
        response["response"]["items"].each do |match_data|
          next if match_data.nil?
          match = Match.find_by(mid: match_data["match_id"])
          unless match.present?
            Match.create(
              status: "Completed",
              mid: match_data["match_id"],
              cid: match_data["competition"]["cid"],
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data["teama"]["name"],
              teama_logo: match_data["teama"]["logo_url"],
              teamb_name: match_data["teamb"]["name"],
              teamb_logo: match_data["teamb"]["logo_url"],
              venue_name: match_data["venue"]["name"],
              venue_location: match_data["venue"]["location"],
              venue_country: match_data["venue"]["country"],
              teama_scores_full: match_data["teama"]["scores_full"] || "null",
              teama_scores: match_data["teama"]["scores"] || "--",
              teama_overs: match_data["teama"]["overs"] || "--",
              teamb_scores_full: match_data["teamb"]["scores_full"] || "null",
              teamb_scores: match_data["teamb"]["scores"] || "--",
              teamb_overs: match_data["teamb"]["overs"] || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"]
            )
            puts "Hello from matchId: #{match_data["match_id"]}"
          else
            match.update(
              title: match_data["title"],
              short_title: match_data["short_title"],
              match_type: match_data["format_str"],
              teama_name: match_data["teama"]["name"],
              teama_logo: match_data["teama"]["logo_url"],
              teamb_name: match_data["teamb"]["name"],
              teamb_logo: match_data["teamb"]["logo_url"],
              venue_name: match_data["venue"]["name"],
              venue_location: match_data["venue"]["location"],
              venue_country: match_data["venue"]["country"],
              teama_scores_full: match_data["teama"]["scores_full"] || "null",
              teama_scores: match_data["teama"]["scores"] || "--",
              teama_overs: match_data["teama"]["overs"] || "--",
              teamb_scores_full: match_data["teamb"]["scores_full"] || "null",
              teamb_scores: match_data["teamb"]["scores"] || "--",
              teamb_overs: match_data["teamb"]["overs"] || "--",
              match_time: match_data["date_start"],
              match_end_time: match_data["date_end"]
            )
            puts "Hello from updated matchId: #{match_data["match_id"]}"
          end
        end
      else
        puts "Invalid response format"
      end
    rescue Exception => e
      puts "API Exception-#{Time.now}-create-matches-Error-#{e}"
    end
  end
end
