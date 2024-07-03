module API
  module V1
    class PlayerSearch < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	Player Search API
      #####################################################################

      resource :playerSearch do
        before { api_params }

        params do
          use :common_params
          requires :page, type: String, allow_blank: false
          optional :playerName, type: String, allow_blank: false
          optional :nationality, type: String, allow_blank: false
          optional :playingRole, type: String, allow_blank: false
        end
        post do
          begin
            require "rest-client"
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            if @device_detail.present?
              players = []
              if params[:playerName].present?
                image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.Szj0UBb1RxBc_-Oh3x4HpwHaEK%26pid%3DApi%26h%3D160&f=1&ipt=be7b6d5d923373168da3040ab69c805162309554986cea46bdca04a88c7d8007&ipo=images"
                allPlayers = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&paged=#{params[:page]}&search=#{params[:playerName]}")
                allPlayersData = JSON.parse(allPlayers)
                allPlayersData["response"]["items"].each do |player|
                  players << {
                    firstName: player["first_name"],
                    lastName: player["last_name"],
                    middleName: player["middle_name"],
                    pId: player["pid"],
                    nationality: player["nationality"].upcase,
                    image: image,
                  }
                end
                { status: 200, message: "Success", allPlayers: players }
              elsif params[:nationality].present?
                image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.Szj0UBb1RxBc_-Oh3x4HpwHaEK%26pid%3DApi%26h%3D160&f=1&ipt=be7b6d5d923373168da3040ab69c805162309554986cea46bdca04a88c7d8007&ipo=images"
                allPlayers = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&paged=#{params[:page]}&country=#{params[:nationality]}")
                allPlayersData = JSON.parse(allPlayers)
                allPlayersData["response"]["items"].each do |player|
                  players << {
                    firstName: player["first_name"],
                    lastName: player["last_name"],
                    middleName: player["middle_name"],
                    pId: player["pid"],
                    nationality: player["nationality"].upcase,
                    image: image,
                  }
                end
                { status: 200, message: "Success", allPlayers: players }
              elsif params[:playingRole].present?
                image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.Szj0UBb1RxBc_-Oh3x4HpwHaEK%26pid%3DApi%26h%3D160&f=1&ipt=be7b6d5d923373168da3040ab69c805162309554986cea46bdca04a88c7d8007&ipo=images"
                allPlayers = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&paged=#{params[:page]}")
                allPlayersData = JSON.parse(allPlayers)
                players = []
                allPlayersData["response"]["items"].each do |player|
                  if player["playing_role"] == params[:playingRole].to_s
                    players << {
                      firstName: player["first_name"],
                      lastName: player["last_name"],
                      middleName: player["middle_name"],
                      pId: player["pid"],
                      nationality: player["nationality"].upcase,
                      image: image,
                    }
                  end
                end
                { status: 200, message: "Success", allPlayers: players }
              else
                image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.Szj0UBb1RxBc_-Oh3x4HpwHaEK%26pid%3DApi%26h%3D160&f=1&ipt=be7b6d5d923373168da3040ab69c805162309554986cea46bdca04a88c7d8007&ipo=images"
                allPlayers = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&paged=#{params[:page]}")
                allPlayersData = JSON.parse(allPlayers)
                allPlayersData["response"]["items"].each do |player|
                  players << {
                    firstName: player["first_name"],
                    lastName: player["last_name"],
                    middleName: player["middle_name"],
                    pId: player["pid"],
                    nationality: player["nationality"].upcase.upcase,
                    image: image,
                  }
                end
                { status: 200, message: "Success", allPlayers: players }
              end
            else
              { status: 500, message: "No device Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- playerSearch --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
