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
              league_data = LeagueDatum.where(lid: params[:leagueId])

              if league_data.empty?
                leagues_res = RestClient.get("https://rest.entitysport.com/v4/tournaments/#{params[:leagueId]}/competitions?token=e9a8cd857f01e5f88127787d3931b63a")
                league_comp_data = JSON.parse(leagues_res.body)

                teams = []
                league_comp_data["response"]["items"]["competitions"].each do |comp|
                  logo = ImagesHelper.search_league_image(comp["title"])[1]

                  matches_res = RestClient.get("https://rest.entitysport.com/v2/competitions/#{comp["cid"]}/matches/?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&&paged=1")
                  matches_data = JSON.parse(matches_res.body)

                  matches_data["response"]["items"].each do |match|
                    win = if match["teama"]["scores"].to_i > match["teamb"]["scores"].to_i
                        "Team A"
                      elsif match["teama"]["scores"].to_i < match["teamb"]["scores"].to_i
                        "Team B"
                      else
                        "Yet To Happen"
                      end

                    leagues_data = LeagueDatum.create(
                      lid: params[:leagueId],
                      matchDate: match["competition"]["datestart"],
                      winning_team: win,
                      logo: logo,
                      cid: comp["cid"],
                      mid: match["match_id"],
                      teama_id: match["teama"]["team_id"],
                      teama_name: match["teama"]["name"],
                      teama_abbr: match["teama"]["short_name"],
                      teama_logo: match["teama"]["logo_url"],
                      teama_scores: match["teama"]["scores"],
                      teama_overs: match["teama"]["overs"],
                      teamb_id: match["teamb"]["team_id"],
                      teamb_name: match["teamb"]["name"],
                      teamb_abbr: match["teamb"]["short_name"],
                      teamb_logo: match["teamb"]["logo_url"],
                      teamb_scores: match["teamb"]["scores"],
                      teamb_overs: match["teamb"]["overs"],
                    )

                    teams << {
                      matchDate: leagues_data.matchDate,
                      winningTeam: leagues_data.winning_team,
                      logo: leagues_data.logo,
                      compId: leagues_data.cid,
                      matchId: leagues_data.mid,
                      teama: {
                        id: leagues_data.teama_id,
                        name: leagues_data.teama_name,
                        short_name: leagues_data.teama_abbr,
                        logo: leagues_data.teama_logo,
                        scores: leagues_data.teama_scores,
                        overs: leagues_data.teama_overs,
                      },
                      teamb: {
                        id: leagues_data.teamb_id,
                        name: leagues_data.teamb_name,
                        short_name: leagues_data.teamb_abbr,
                        logo: leagues_data.teamb_logo,
                        scores: leagues_data.teamb_scores,
                        overs: leagues_data.teamb_overs,
                      },
                    }
                  end
                end

                { status: 200, message: MSG_SUCCESS, teams: teams }
              else
                teams = league_data.map do |league|
                  {
                    matchDate: league.matchDate,
                    winningTeam: league.winning_team,
                    logo: league.logo,
                    compId: league.cid,
                    matchId: league.mid,
                    teama: {
                      id: league.teama_id,
                      name: league.teama_name,
                      short_name: league.teama_abbr,
                      logo: league.teama_logo,
                      scores: league.teama_scores,
                      overs: league.teama_overs,
                    },
                    teamb: {
                      id: league.teamb_id,
                      name: league.teamb_name,
                      short_name: league.teamb_abbr,
                      logo: league.teamb_logo,
                      scores: league.teamb_scores,
                      overs: league.teamb_overs,
                    },
                  }
                end

                { status: 200, message: MSG_SUCCESS, teams: teams }
              end
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
