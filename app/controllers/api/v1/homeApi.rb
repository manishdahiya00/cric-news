module API
  module V1
    class HomeApi < Grape::API
      include API::V1::Defaults


      resource :home do
        before {api_params}


        params do
          use :common_params
        end
        post do
          begin
            device = DeviceDetail.find_by(device_id: params[:deviceId],security_token: params[:securityToken])
            if device.present?
              liveMatches = fetch_matches("live")
              upcomingMatches = fetch_matches("upcoming")
              trendingNews = []
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
              {status: 200, message: MSG_SUCCESS, liveMatches: liveMatches || [], upcomingMatches: upcomingMatches || [], trendingNews: trendingNews || []}
            else
              {status: 500, message: "No device Found"}
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- homeApi --- Params: #{params.inspect}  Error: #{e.message}"
            {status: 500, message: MSG_ERROR, error: e}
          end
        end
      end

    end
  end
end
