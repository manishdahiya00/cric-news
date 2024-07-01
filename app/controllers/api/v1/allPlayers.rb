module API
  module V1
    class AllPlayers < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	All Players API
      #####################################################################

      resource :allPlayers do
        before { api_params }

        params do
          use :common_params
          requires :page, type: String, allow_blank: false
        end
        post do
          begin
            require "rest-client"
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            if @device_detail.present?
              allPlayers = RestClient.get("https://rest.entitysport.com/v2/players?token=e9a8cd857f01e5f88127787d3931b63a&per_page=50&pages=#{params[:page]}")
              allPlayersData = JSON.parse(allPlayers)
              { status: 200, message: "Success", allPlayers: allPlayersData["response"]["items"] }
            else
              { status: 500, message: "No device Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- allPlayers --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
