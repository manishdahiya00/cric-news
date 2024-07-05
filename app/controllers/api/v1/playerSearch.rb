module API
  module V1
    class PlayerSearch < Grape::API
      include API::V1::Defaults

      resource :playerSearch do
        before { api_params }

        params do
          use :common_params
          requires :page, type: Integer, allow_blank: false
          optional :playerName, type: String, allow_blank: true
          optional :nationality, type: String, allow_blank: true
          optional :playingRole, type: String, allow_blank: true
        end

        post do
          begin
            @user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            if @user.present?
              players = []

              case
              when params[:playerName].present?
                players = fetch_players("search=#{params[:playerName]}&paged=#{params[:page]}&country=#{params[:country]}")
              when params[:nationality].present?
                players = fetch_players("country=#{params[:nationality]}&paged=#{params[:page]}&search=#{params[:playingRole]}")
              when params[:playingRole].present?
                image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.Szj0UBb1RxBc_-Oh3x4HpwHaEK%26pid%3DApi%26h%3D160&f=1&ipt=be7b6d5d923373168da3040ab69c805162309554986cea46bdca04a88c7d8007&ipo=images"
                res = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&country=#{params[:nationality]}&paged=#{params[:page]}&search=#{params[:playingRole]}&per_page=50")
                all_players = JSON.parse(res)
                players = all_players["response"]["items"].select do |player|
                  player["playing_role"] == params[:playingRole]
                end.map do |player|
                  {
                    firstName: player["first_name"],
                    lastName: player["last_name"],
                    middleName: player["middle_name"],
                    pId: player["pid"],
                    nationality: player["nationality"].upcase,
                    image: image,
                  }
                end
              else
                players = fetch_players("page=#{params[:page]}")
              end

              { status: 200, message: "Success", allPlayers: players }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception: #{e.message}"
            { status: 500, message: "Internal server error", error: e }
          end
        end
      end

      helpers do
        def fetch_players(param)
          image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.Szj0UBb1RxBc_-Oh3x4HpwHaEK%26pid%3DApi%26h%3D160&f=1&ipt=be7b6d5d923373168da3040ab69c805162309554986cea46bdca04a88c7d8007&ipo=images"
          response = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&#{param}&per_page=50")
          players_data = JSON.parse(response.body)["response"]["items"]
          players = players_data.map do |player|
            {
              firstName: player["first_name"],
              lastName: player["last_name"],
              middleName: player["middle_name"],
              pId: player["pid"],
              nationality: player["nationality"].upcase,
              image: image,
            }
          end
        end
      end
    end
  end
end
