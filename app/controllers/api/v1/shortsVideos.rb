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
              "http://localhost:5000/api/v1/cricketReels",
              {
                userId: "1",
                securityToken: "1",
                versionName: "1",
                versionCode: "1",
                page: params[:page],
              }.to_json,
              { content_type: :json, accept: :json }
            )

            puts @res
            @reels = JSON.parse(@res.body)["reels"]
            @shorts = []
            @reels.each do |reel|
              @shorts << {
                reelId: reel["reelId"],
                reelUrl: reel["videoUrl"],
              }
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
