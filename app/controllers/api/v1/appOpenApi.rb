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
        end
        post do
          begin
            @user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            unless @user.present?
              { status: 500, message: MSG_ERROR, error: "No User Found" }
            else
              @app_open = AppOpen.create(
                user_id: params[:userId],
                version_name: params[:versionName],
                version_code: params[:versionCode],
                security_token: params[:securityToken],
                source_ip: request.ip,
              )
              { status: 200, message: MSG_SUCCESS, socialName: @user.social_name, socialEmail: @user.social_email, socialImgUrl: @user.social_img_url, appUrl: "", forceUpdate: false }
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
