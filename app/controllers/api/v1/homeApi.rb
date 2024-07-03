module API
  module V1
    class HomeApi < Grape::API
      include API::V1::Defaults

      resource :home do
        before { api_params }

        params do
          use :common_params
        end
        post do
          begin
            device = DeviceDetail.find_by(device_id: params[:deviceId], security_token: params[:securityToken])
            if device.present?
              liveMatches = fetch_matches("live")
              upcomingMatches = fetch_matches("upcoming")
              trendingNews = []
              leagues = []
              require "rest-client"
              news = RestClient.get("https://newsapi.org/v2/top-headlines?country=in&category=sports&q=cricket&apiKey=c3d60ac64c52432cad1a4f43dd4ec732")
              news_response = JSON.parse(news)
              news_response["articles"].each do |res|
                trendingNews << {
                  name: res["source"]["name"],
                  author: res["author"],
                  image: res["urlToImage"],
                  title: res["title"],
                  desc: res["description"],
                  content: res["content"],
                  url: res["url"],
                  publishedAt: Time.parse(res["publishedAt"]).strftime("%d/%m/%y"),
                }
              end
              leagues_res = RestClient.get("https://rest.entitysport.com/v4/tournaments?token=e9a8cd857f01e5f88127787d3931b63a")
              leagues_data = JSON.parse(leagues_res)
              leagues_data["response"]["items"].each do |league|
                leagues << {
                  tournamentId: league["tournament_id"],
                  tournamentName: league["name"],
                }
              end
              { status: 200, message: MSG_SUCCESS, liveMatches: liveMatches || [], upcomingMatches: upcomingMatches || [], trendingNews: trendingNews || [], leagues: leagues || [] }
            else
              { status: 500, message: "No device Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- homeApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
