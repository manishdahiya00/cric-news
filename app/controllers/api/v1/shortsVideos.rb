module API
  module V1
    class ShortsVideos < Grape::API
      include API::V1::Defaults

      resource :shortsVideos do
        before { api_params }

        params do
          use :common_params
          requires :page, type: String, allow_blank: false
        end
        post do
          begin
            @user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            unless @user.present?
              return { status: 500, message: MSG_ERROR, error: "No User Found" }
            end

            require "rest-client"
            @res = RestClient.post(
              "https://orilshorts.app/api/v1/reelsList",
              {
                userId: "3",
                securityToken: "e493890d-fa6d-4670-85c2-348afb3f791d",
                versionName: "1",
                versionCode: "1",
                page: params[:page],
              }.to_json,
              { content_type: :json, accept: :json }
            )

            @reels = JSON.parse(@res.body)["reels"]
            @shorts = []
            @reels.each do |reel|
              puts reel
              if reel["reelDescription"].include?("cricket")
                @shorts << {
                  reelId: reel["reelId"],
                  reelUrl: reel["videoUrl"],
                }
              end
            end
            { status: 200, message: MSG_SUCCESS, shorts: @shorts || [] }
          rescue StandardError => e
            Rails.logger.error "API Exception => #{Time.now} --- shortsVideosApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
