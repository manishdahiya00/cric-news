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
            device = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            if device.present?
              teams = []
              league_res = RestClient.get("https://rest.entitysport.com/v4/tournaments?token=e9a8cd857f01e5f88127787d3931b63a")
              leagues_comp_res = RestClient.get("https://rest.entitysport.com/v4/tournaments/#{params[:leagueId]}/competitions?token=e9a8cd857f01e5f88127787d3931b63a")
              league_data = JSON.parse(league_res)
              league_comp_data = JSON.parse(leagues_comp_res)
              league_comp_data["response"]["items"]["competitions"].each do |comp|
                matches_res = RestClient.get("https://rest.entitysport.com/v2/competitions/#{comp["cid"]}/matches/?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&&paged=1")
                matches_data = JSON.parse(matches_res)
                matches_data["response"]["items"].each do |match|
                  if match["teama"]["scores"].to_i > match["teamb"]["scores"].to_i
                    win = "Team A"
                  elsif match["teama"]["scores"].to_i < match["teamb"]["scores"].to_i
                    win = "Team B"
                  else
                    win = "Yet To Happen"
                  end
                  teams << [
                    {
                      matchDate: match["competition"]["datestart"],
                      winningTeam: win,
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
                    },
                  ]
                end
              end
              { status: 200, message: MSG_SUCCESS, teams: teams || [] }
            else
              { status: 500, message: "No device Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- homeApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
