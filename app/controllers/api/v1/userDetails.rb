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
        end
        post do
          begin
            ip_addr = request.ip
            genuine_user = google_validator(params[:socialToken], params[:socialEmail])
            if genuine_user
              user = UserDetail.find_by(social_email: params[:socialEmail], social_id: params[:socialId])
              if user.present?
                { status: 200, message: MSG_SUCCESS, userId: user.id, security_token: user.security_token }
              else
                @user_detail = UserDetail.create(device_id: params[:deviceId], device_type: params[:deviceType], device_name: params[:deviceName], social_type: params[:socialType], social_id: params[:socialId], social_email: params[:socialEmail], social_name: params[:socialName], social_img_url: params[:socialImgUrl], advertising_id: params[:advertisingId], version_name: params[:versionName], version_code: params[:versionCode], utm_source: params[:utmSource], utm_medium: params[:utmMedium], utm_term: params[:utmTerm], utm_content: params[:utmContent], utm_campaign: params[:utmCampaign], referrer_url: params[:referrerUrl], security_token: SecureRandom.hex, source_ip: ip_addr, refer_code: SecureRandom.hex(6).upcase)
                { status: 200, message: MSG_SUCCESS, userId: @user_detail.id, security_token: @user_detail.security_token }
              end
            else
              { status: 500, message: MSG_ERROR, error: "No Tricks Allowed" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- userDetailApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :defaultUser do
        before { api_params }

        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end

        post do
          begin
            ip_addr = request.ip
            if params[:email] == "testingyash8@gmail.com" && params[:password] == "yash@123"
              user = User.find_by(social_email: params[:email])
              if user.present?
                res = { message: MSG_SUCCESS, status: 200, userId: user.id, securityToken: user.security_token }
                LogsHelper.logs(res, request)
                return res
              else
                new_user = User.create(social_name: "Testing Yash", social_email: params[:email], security_token: "acc7106fe5009609", source_ip: ip_addr, refer_code: SecureRandom.hex(6).upcase, social_img_url: "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png")
                res = { message: MSG_SUCCESS, status: 200, userId: new_user.id, securityToken: new_user.security_token }
                logs(res)
                return res
              end
            else
              res = { message: "Invalid Email Or Password", status: 500 }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - defaultUser - #{params.inspect} - Error - #{e}"
            Rails.logger.error log
            LogsHelper.logs(log, request)
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
