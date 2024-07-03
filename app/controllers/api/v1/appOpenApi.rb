module API
  module V1
    class AppOpenApi < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	App Open API
      #####################################################################

      resource :appOpen do
        before { api_params }

        params do
          use :common_params
          optional :appUrl, type: String, allow_blank: false, default: ""
          optional :socialName, type: String, allow_blank: false, default: ""
          optional :socialEmail, type: String, allow_blank: false, default: ""
          optional :socialImgUrl, type: String, allow_blank: false, default: ""
          optional :forceUpdate, type: String, allow_blank: false, default: ""
        end
        post do
          begin
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            unless @device_detail.present?
              { status: 500, message: MSG_ERROR, error: "No Device Found" }
            else
              @app_open = AppOpen.create(
                device_id: params[:deviceId],
                version_name: params[:versionName],
                version_code: params[:versionCode],
                security_token: params[:securityToken],
                source_ip: request.ip,
              )
              { status: 200, message: MSG_SUCCESS, socialName: @app_open.social_name, socialEmail: @app_open.social_email, socialImgUrl: @app_open.social_img_url, appUrl: @app_open.app_url, forceUpdate: @app_open.force_update }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- appOpenApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
