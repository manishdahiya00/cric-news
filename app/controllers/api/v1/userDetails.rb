module API
  module V1
    class UserDetails < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############	====>    	    	User Details API
      #####################################################################

      helpers do
        def google_validator(token, socialemail)
          validator = GoogleIDToken::Validator.new(expiry: 300)
          begin
            token_segments = token.split(".")
            if token_segments.count == 3
              required_audience = JWT.decode(token, nil, false)[0]["aud"]
              payload = validator.check(token, required_audience)
              if (payload["email"] == socialemail)
                return true
              else
                return false
              end
            else
              return false
            end
          rescue GoogleIDToken::ValidationError => e
            return false
          end
        end
      end

      resource :userDetail do
        before { api_params }

        params do
          requires :deviceId, type: String, allow_blank: false
          requires :deviceType, type: String, allow_blank: true
          requires :deviceName, type: String, allow_blank: true
          requires :socialType, type: String, allow_blank: false
          requires :socialId, type: String, allow_blank: false
          requires :socialToken, type: String, allow_blank: false
          requires :socialEmail, type: String, allow_blank: true
          requires :socialName, type: String, allow_blank: true
          requires :socialImgUrl, type: String, allow_blank: true
          requires :advertisingId, type: String, allow_blank: true
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          requires :utmSource, type: String, allow_blank: true
          requires :utmMedium, type: String, allow_blank: true
          requires :utmTerm, type: String, allow_blank: true
          requires :utmContent, type: String, allow_blank: true
          requires :utmCampaign, type: String, allow_blank: true
          requires :referrerUrl, type: String, allow_blank: true
          requires :securityToken, type: String, allow_blank: false
        end
        post do
          begin
            ip_addr = request.ip
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            if @device_detail.present?
              genuine_user = google_validator(params[:socialToken], params[:socialEmail])
              if genuine_user
                @user_detail = UserDetail.create(device_id: @device_detail.device_id, device_type: params[:deviceType], device_name: params[:deviceName], social_type: params[:socialType], social_id: params[:socialId], social_email: params[:socialEmail], social_name: params[:socialName], social_img_url: params[:socialImgUrl], advertising_id: params[:advertisingId], version_name: params[:versionName], version_code: params[:versionCode], utm_source: params[:utmSource], utm_medium: params[:utmMedium], utm_term: params[:utmTerm], utm_content: params[:utmContent], utm_campaign: params[:utmCampaign], referrer_url: params[:referrerUrl], security_token: params[:securityToken], source_ip: ip_addr, refer_code: SecureRandom.hex(6).upcase)
                { status: 200, message: MSG_SUCCESS, userId: @user_detail.id, security_token: @user_detail.security_token }
              else
                { status: 200, message: MSG_ERROR, error: "No Tricks Allowed" }
              end
            else
              { status: 200, message: MSG_ERROR, error: "No Device Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- userDetailApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
