module API
  module V1
    class PlayerData < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############   ===>             Player Data API
      #####################################################################

      resource :playerData do
        before { api_params }

        params do
          use :common_params
          requires :playerId, type: String, allow_blank: false
        end
        post do
          begin
            require "rest-client"
            @user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            if @user.present?
              player_stats = RestClient.get("https://rest.entitysport.com/v2/players/#{params[:playerId]}/stats?token=e9a8cd857f01e5f88127787d3931b63a")
              player_stats_data = JSON.parse(player_stats)
              player_info = player_stats_data["response"]["player"]
              image = ImagesHelper.search_player_image(player_info["first_name"])[2]
              countryFlag = ImagesHelper.search_country_flag_image(player_info["nationality"])[2]
              playerInfoData = [
                playerInfo: {
                  playerImage: image || "--",
                  countryFlag: countryFlag,
                  title: player_info["title"].to_s.presence || "--",
                  short_name: player_info["short_name"].to_s.presence || "--",
                  first_name: player_info["first_name"].to_s.presence || "--",
                  last_name: player_info["last_name"].to_s.presence || "--",
                  middle_name: player_info["middle_name"].to_s.presence || "--",
                  birthdate: player_info["birthdate"].to_s.presence || "--",
                  country: player_info["country"].to_s.presence || "--",
                  logo_url: player_info["logo_url"].to_s.presence || "--",
                  batting_style: player_info["batting_style"].to_s.presence || "--",
                  bowling_style: player_info["bowling_style"].to_s.presence || "--",
                  alt_name: player_info["alt_name"].to_s.presence || "--",
                  thumb_url: player_info["thumb_url"].to_s.presence || "--",
                  nationality: player_info["nationality"].to_s.upcase.presence || "--",
                },
                batting: [
                  {
                    title: "First Class",
                    matches: player_stats_data.dig("response", "batting", "firstclass", "matches").to_s.presence.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "firstclass", "innings").to_s.presence.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "firstclass", "notout").to_s.presence.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "firstclass", "runs").to_s.presence.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "firstclass", "balls").to_s.presence.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "firstclass", "catches").to_s.presence.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "firstclass", "stumpings").to_s.presence.presence || "--",
                  },
                  {
                    title: "List A",
                    matches: player_stats_data.dig("response", "batting", "lista", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "lista", "innings").to_s.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "lista", "notout").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "lista", "runs").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "lista", "balls").to_s.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "lista", "catches").to_s.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "lista", "stumpings").to_s.presence || "--",
                  },
                  {
                    title: "Odi",
                    matches: player_stats_data.dig("response", "batting", "odi", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "odi", "innings").to_s.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "odi", "notout").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "odi", "runs").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "odi", "balls").to_s.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "odi", "catches").to_s.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "odi", "stumpings").to_s.presence || "--",
                  },
                  {
                    title: "T10",
                    matches: player_stats_data.dig("response", "batting", "t10", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "t10", "innings").to_s.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "t10", "notout").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "t10", "runs").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "t10", "balls").to_s.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "t10", "catches").to_s.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "t10", "stumpings").to_s.presence || "--",
                  },
                  {
                    title: "T20",
                    matches: player_stats_data.dig("response", "batting", "t20", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "t20", "innings").to_s.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "t20", "notout").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "t20", "runs").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "t20", "balls").to_s.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "t20", "catches").to_s.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "t20", "stumpings").to_s.presence || "--",
                  },
                  {
                    title: "T20i",
                    matches: player_stats_data.dig("response", "batting", "t20i", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "t20i", "innings").to_s.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "t20i", "notout").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "t20i", "runs").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "t20i", "balls").to_s.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "t20i", "catches").to_s.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "t20i", "stumpings").to_s.presence || "--",
                  },
                  {
                    title: "Test",
                    matches: player_stats_data.dig("response", "batting", "test", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "batting", "test", "innings").to_s.presence || "--",
                    notout: player_stats_data.dig("response", "batting", "test", "notout").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "batting", "test", "runs").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "batting", "test", "balls").to_s.presence || "--",
                    catches: player_stats_data.dig("response", "batting", "test", "catches").to_s.presence || "--",
                    stumpings: player_stats_data.dig("response", "batting", "test", "stumpings").to_s.presence || "--",
                  },
                ],
                bowling: [
                  {
                    title: "First Class",
                    matches: player_stats_data.dig("response", "bowling", "firstclass", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "firstclass", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "firstclass", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "firstclass", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "firstclass", "overs").to_s.presence || "--",
                    strike: player_stats_data.dig("response", "bowling", "firstclass", "strike").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "firstclass", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "firstclass", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "firstclass", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "firstclass", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "firstclass", "average").to_s.presence || "--",
                  },
                  {
                    title: "List A",
                    matches: player_stats_data.dig("response", "bowling", "lista", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "lista", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "lista", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "lista", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "lista", "overs").to_s.presence || "--",
                    strike: player_stats_data.dig("response", "bowling", "lista", "strike").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "lista", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "lista", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "lista", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "lista", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "lista", "average").to_s.presence || "--",
                  },
                  {
                    title: "Odi",
                    matches: player_stats_data.dig("response", "bowling", "odi", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "odi", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "odi", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "odi", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "odi", "overs").to_s.presence || "--",
                    strike: player_stats_data.dig("response", "bowling", "odi", "strike").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "odi", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "odi", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "odi", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "odi", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "odi", "average").to_s.presence || "--",
                  },
                  {
                    title: "T10",
                    matches: player_stats_data.dig("response", "bowling", "t10", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "t10", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "t10", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "t10", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "t10", "overs").to_s.presence || "--",
                    strike: player_stats_data.dig("response", "bowling", "t10", "strike").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "t10", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "t10", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "t10", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "t10", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "t10", "average").to_s.presence || "--",
                  },
                  {
                    title: "T20",
                    matches: player_stats_data.dig("response", "bowling", "t20", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "t20", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "t20", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "t20", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "t20", "overs").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "t20", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "t20", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "t20", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "t20", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "t20", "average").to_s.presence || "--",
                  },
                  {
                    title: "T20i",
                    matches: player_stats_data.dig("response", "bowling", "t20i", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "t20i", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "t20i", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "t20i", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "t20i", "overs").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "t20i", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "t20i", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "t20i", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "t20i", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "t20i", "average").to_s.presence || "--",
                  },
                  {
                    title: "Test",
                    matches: player_stats_data.dig("response", "bowling", "test", "matches").to_s.presence || "--",
                    innings: player_stats_data.dig("response", "bowling", "test", "innings").to_s.presence || "--",
                    balls: player_stats_data.dig("response", "bowling", "test", "balls").to_s.presence || "--",
                    runs: player_stats_data.dig("response", "bowling", "test", "runs").to_s.presence || "--",
                    overs: player_stats_data.dig("response", "bowling", "test", "overs").to_s.presence || "--",
                    wickets: player_stats_data.dig("response", "bowling", "test", "wickets").to_s.presence || "--",
                    best_innings: player_stats_data.dig("response", "bowling", "test", "best_innings").to_s.presence || "--",
                    best_match: player_stats_data.dig("response", "bowling", "test", "best_match").to_s.presence || "--",
                    econ: player_stats_data.dig("response", "bowling", "test", "econ").to_s.presence || "--",
                    average: player_stats_data.dig("response", "bowling", "test", "average").to_s.presence || "--",
                  },
                ],

              ]

              { status: 200, message: "Success", playerInfo: playerInfoData || [] }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- playerData --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: "Error", error: e.message }
          end
        end
      end
    end
  end
end
