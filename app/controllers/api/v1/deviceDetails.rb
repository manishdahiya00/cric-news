module API
  module V1
    class DeviceDetails < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	Device Details API
      #####################################################################

      resource :deviceDetail do
        before { api_params }

        params do
          requires :deviceId, type: String, allow_blank: false
          requires :deviceType, type: String, allow_blank: false
          requires :deviceName, type: String, allow_blank: false
          requires :advertisingId, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          optional :utmSource, type: String, allow_blank: true
          optional :utmMedium, type: String, allow_blank: true
          optional :utmCampaign, type: String, allow_blank: true
          optional :utmContent, type: String, allow_blank: true
          optional :utmTerm, type: String, allow_blank: true
          optional :referrerUrl, type: String, allow_blank: true
        end
        post do
          begin
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId])
            unless @device_detail.present?
              @security_token = SecureRandom.hex(12)
              @new_device_detail = DeviceDetail.create(device_id: params[:deviceId], device_type: params[:deviceType], device_name: params[:deviceName], advertising_id: params[:advertisingId], version_code: params[:versionCode], version_name: params[:versionName], utm_source: params[:utmSource], utm_medium: params[:utmMedium], utm_campaign: params[:utmCampaign], utm_content: params[:utmContent], utm_term: params[:utmTerm], referrer_url: params[:referrerUrl], security_token: @security_token)
              { status: 200, message: MSG_SUCCESS, deviceId: @new_device_detail.device_id, securityToken: @new_device_detail.security_token }
            else
              { status: 200, message: MSG_SUCCESS, deviceId: @device_detail.device_id, securityToken: @device_detail.security_token }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- deviceDetailApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
