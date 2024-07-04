module API
  module V1
    class Profile < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	Profile API
      #####################################################################

      resource :profile do
        before { api_params }

        params do
          use :common_params
          requires :userId, type: :String, allow_blank: false
        end
        post do
          begin
            device = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            if device.present?
              user = UserDetail.find(params[:userId])
              if user.present?
                { status: 200, message: MSG_SUCCESS, name: user.social_name, email: user.social_email, profilePic: user.social_img_url }
              else
                { status: 500, message: "No User Found" }
              end
            else
              { status: 500, message: "No device Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- profile --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
