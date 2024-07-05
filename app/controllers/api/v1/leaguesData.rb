module API
  module V1
    class LeaguesData < Grape::API
      include API::V1::Defaults

      resource :leagueData do
        before { api_params }

        params do
          use :common_params
          requires :leagueId, type: String, allow_blank: false
        end

        post do
          begin
            user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            if user.present?
              require "rest-client"
              require "json"

              league_res = RestClient.get("https://rest.entitysport.com/v4/tournaments?token=e9a8cd857f01e5f88127787d3931b63a")
              leagues_comp_res = RestClient.get("https://rest.entitysport.com/v4/tournaments/#{params[:leagueId]}/competitions?token=e9a8cd857f01e5f88127787d3931b63a")

              league_data = JSON.parse(league_res.body)
              league_comp_data = JSON.parse(leagues_comp_res.body)

              teams = []
              logo = ""
              league_data["response"]["items"].each_with_index do |league|
              end
              league_comp_data["response"]["items"]["competitions"].each do |comp|
                logo = ImagesHelper.search_league_image(comp["title"])[1]
                matches_res = RestClient.get("https://rest.entitysport.com/v2/competitions/#{comp["cid"]}/matches/?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&&paged=1")
                matches_data = JSON.parse(matches_res.body)

                matches_data["response"]["items"].each_with_index do |match, index|
                  win = if match["teama"]["scores"].to_i > match["teamb"]["scores"].to_i
                      "Team A"
                    elsif match["teama"]["scores"].to_i < match["teamb"]["scores"].to_i
                      "Team B"
                    else
                      "Yet To Happen"
                    end
                  teams << {
                    matchDate: match["competition"]["datestart"],
                    winningTeam: win,
                    logo: logo,
                    compId: comp["cid"],
                    matchId: match["match_id"].to_s,
                    teama: {
                      id: match["teama"]["team_id"],
                      name: match["teama"]["name"],
                      short_name: match["teama"]["short_name"],
                      logo: match["teama"]["logo_url"],
                      scores: match["teama"]["scores"],
                      overs: match["teama"]["overs"],
                    },
                    teamb: {
                      id: match["teamb"]["team_id"],
                      name: match["teamb"]["name"],
                      short_name: match["teamb"]["short_name"],
                      logo: match["teamb"]["logo_url"],
                      scores: match["teamb"]["scores"],
                      overs: match["teamb"]["overs"],
                    },
                  }
                end
              end

              { status: 200, message: MSG_SUCCESS, teams: teams }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- leagueData --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
