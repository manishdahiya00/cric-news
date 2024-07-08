module API
  module V1
    class LiveMatchData < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	Match Squads API
      #####################################################################

      resource :liveMatchData do
        params do
          use :common_params
          requires :matchId, type: String, allow_blank: false
          requires :compId, type: String, allow_blank: false
        end
        post do
          begin
            user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            if user.present?
              require "rest-client"

              team = Team.find_by(mid: params[:matchId])
              scorecard = Scorecard.find_by(mid: params[:matchId])
              unless team.present? && scorecard.present?
                match_data_url = "https://rest.entitysport.com/v2/competitions/#{params[:compId]}/squads/#{params[:matchId]}?token=e9a8cd857f01e5f88127787d3931b63a"
                match_data_res = RestClient.get(match_data_url)
                match_data = JSON.parse(match_data_res)
                teama = match_data["response"]["squads"][0]["players"]
                teamb = match_data["response"]["squads"][1]["players"]
                match_res = RestClient.get("https://rest.entitysport.com/v2/matches/#{params[:matchId]}/info?token=e9a8cd857f01e5f88127787d3931b63a")
                matchData = JSON.parse(match_res)
                match = matchData["response"]
                scorecard_url = "https://rest.entitysport.com/v2/matches/#{params[:matchId]}/scorecard?token=e9a8cd857f01e5f88127787d3931b63a"
                scorecard_res = RestClient.get(scorecard_url)
                scorecard_data = JSON.parse(scorecard_res)
                team = Team.create(
                  mid: params[:matchId],
                  match_type: match["format_str"],
                  teama_name: match_data["response"]["squads"][0]["team"]["title"],
                  teamb_name: match_data["response"]["squads"][1]["team"]["title"],
                  teama_abbr: match_data["response"]["squads"][0]["team"]["abbr"],
                  teamb_abbr: match_data["response"]["squads"][1]["team"]["abbr"],
                  teama_url: match_data["response"]["squads"][0]["team"]["logo_url"],
                  teamb_url: match_data["response"]["squads"][1]["team"]["logo_url"],
                  teama_scores: match["teama"]["scores_full"],
                  teamb_scores: match["teamb"]["scores_full"],
                  teama: match_data["response"]["squads"][0]["players"],
                  teamb: match_data["response"]["squads"][1]["players"],
                )
                scorecard = Scorecard.create(
                  mid: scorecard_data["response"]["match_id"],
                  teama_id: scorecard_data["response"]["teama"]["team_id"],
                  teamb_id: scorecard_data["response"]["teamb"]["team_id"],
                  teama_innings: scorecard_data["response"]["innings"][0] || [],
                  teamb_innings: scorecard_data["response"]["innings"][1] || [],
                )
              end

              data = {
                teama_name: team.teama_name,
                teama_short_name: team.teama_abbr,
                teamb_name: team.teamb_name,
                teamb_short_name: team.teamb_abbr,
                teama_logo: team.teama_url,
                teamb_logo: team.teamb_url,
                teama_scores: team.teama_scores,
                teamb_scores: team.teamb_scores,
                match_type: team.match_type,
                teama_players: team.teama,
                teamb_players: team.teamb,
                scores: {
                  teama: scorecard.teama_innings || [],
                  teamb: scorecard.teamb_innings || [],
                },
              }
              teama_innings = scorecard.teama_innings || []
              teamb_innings = scorecard.teamb_innings || []

              teama_batsman_total_runs = 0
              teama_batsman_total_balls = 0
              teama_batsman_total_fours = 0
              teama_batsman_total_sixes = 0
              teama_batsman_total_strike_rate = 0.0
              teama_batsman_count = 0

              teama_bowlers_total_runs = 0
              teama_bowlers_total_balls = 0
              teama_bowlers_total_fours = 0
              teama_bowlers_total_sixes = 0
              teama_bowlers_total_strike_rate = 0.0
              teama_bowlers_batsman_count = 0

              teama_innings["batsmen"].each do |batsman|
                teama_batsman_total_runs += batsman["runs"].to_i
                teama_batsman_total_balls += batsman["balls"].to_i
                teama_batsman_total_fours += batsman["fours"].to_i
                teama_batsman_total_sixes += batsman["sixes"].to_i
                teama_batsman_total_strike_rate += batsman["strike_rate"].to_f
                teama_batsman_count += 1
              end
              teama_innings["bowlers"].each do |bowler|
                teama_bowlers_total_runs += bowler["runs"].to_i
                teama_bowlers_total_balls += bowler["balls"].to_i
                teama_bowlers_total_fours += bowler["fours"].to_i
                teama_bowlers_total_sixes += bowler["sixes"].to_i
                teama_bowlers_total_strike_rate += bowler["strike_rate"].to_f
                teama_bowlers_batsman_count += 1
              end

              teamb_batsman_total_runs = 0
              teamb_batsman_total_balls = 0
              teamb_batsman_total_fours = 0
              teamb_batsman_total_sixes = 0
              teamb_batsman_total_strike_rate = 0.0
              teamb_batsman_count = 0

              teamb_bowlers_total_runs = 0
              teamb_bowlers_total_balls = 0
              teamb_bowlers_total_fours = 0
              teamb_bowlers_total_sixes = 0
              teamb_bowlers_total_strike_rate = 0.0
              teamb_bowlers_count = 0

              teamb_innings["batsmen"].each do |batsman|
                teamb_batsman_total_runs += batsman["runs"].to_i
                teamb_batsman_total_balls += batsman["balls"].to_i
                teamb_batsman_total_fours += batsman["fours"].to_i
                teamb_batsman_total_sixes += batsman["sixes"].to_i
                teamb_batsman_total_strike_rate += batsman["strike_rate"].to_f
                teamb_batsman_count += 1
              end

              teamb_innings["bowlers"].each do |bowler|
                teamb_bowlers_total_runs += bowler["runs"].to_i
                teamb_bowlers_total_balls += bowler["balls"].to_i
                teamb_bowlers_total_fours += bowler["fours"].to_i
                teamb_bowlers_total_sixes += bowler["sixes"].to_i
                teamb_bowlers_total_strike_rate += bowler["strike_rate"].to_f
                teamb_bowlers_count += 1
              end

              teama_batsman_average_strike_rate = teama_batsman_count > 0 ? teama_batsman_total_strike_rate / teama_batsman_count : 0
              teama_bowlers_average_strike_rate = teama_batsman_count > 0 ? teama_bowlers_total_strike_rate / teama_batsman_count : 0
              teamb_batsman_average_strike_rate = teamb_batsman_count > 0 ? teamb_batsman_total_strike_rate / teamb_batsman_count : 0
              teamb_bowlers_average_strike_rate = teamb_batsman_count > 0 ? teamb_bowlers_total_strike_rate / teamb_batsman_count : 0
              teama_batsman_totals = {
                total_runs: teama_batsman_total_runs,
                total_balls: teama_batsman_total_balls,
                total_fours: teama_batsman_total_fours,
                total_sixes: teama_batsman_total_sixes,
                average_strike_rate: teama_batsman_average_strike_rate,
              }
              teama_bowlers_totals = {
                total_runs: teama_bowlers_total_runs,
                total_fours: teama_bowlers_total_fours,
                total_sixes: teama_bowlers_total_sixes,
                average_strike_rate: teama_bowlers_average_strike_rate,
              }
              teamb_batsman_totals = {
                total_runs: teama_batsman_total_runs,
                total_balls: teama_batsman_total_balls,
                total_fours: teama_batsman_total_fours,
                total_sixes: teama_batsman_total_sixes,
                average_strike_rate: teamb_batsman_average_strike_rate,
              }
              teamb_bowlers_totals = {
                total_runs: teamb_bowlers_total_runs,
                total_balls: teamb_bowlers_total_balls,
                total_fours: teamb_bowlers_total_fours,
                total_sixes: teamb_bowlers_total_sixes,
                average_strike_rate: teamb_bowlers_average_strike_rate,
              }
              { status: 200, message: MSG_SUCCESS, matchData: data, teama__batsman_total: teama_batsman_totals, teamb__batsman_total: teamb_batsman_totals, teama__bowlers_total: teama_bowlers_totals, teamb__bowlers_total: teamb_bowlers_totals }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- liveMatchDataApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
