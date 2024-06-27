module API
  module V1
    class PlayerData < Grape::API
      include API::V1::Defaults


      #####################################################################
		  #############	====>    	    	Player Data API
			#####################################################################

      resource :playerData do
        before {api_params}

        params do
          use :common_params
          requires :playerId, type: String, allow_blank: false
        end
        post do
          begin
            require "rest-client"
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId],security_token: params[:securityToken])
            if @device_detail.present?
              player_stats = RestClient.get("https://rest.entitysport.com/v2/players/#{params[:playerId]}/stats?token=e9a8cd857f01e5f88127787d3931b63a")
              player_stats_data = JSON.parse(player_stats)
              {status: 200, message: "Success",playerInfo: player_stats_data["response"]}
            else
              {status: 500, message: "No device Found"}
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- playerData --- Params: #{params.inspect}  Error: #{e.message}"
            {status: 500, message: MSG_ERROR, error: e}
          end
        end
      end
    end
  end
end
