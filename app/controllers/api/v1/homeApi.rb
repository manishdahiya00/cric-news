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
            user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            if user.present?
              liveMatches = fetch_matches("live")
              upcomingMatches = fetch_matches("upcoming")
              trendingNews = []
              leagues = []
              news = News.where("published_at >= ?", Date.today - 1.day)
              if news.empty?
                require "rest-client"
                response = RestClient.get("https://newsapi.org/v2/top-headlines?country=in&category=sports&q=cricket&apiKey=#{NEWS_API_KEY.sample}")
                news_response = JSON.parse(response)
                news_response["articles"].each do |res|
                  trending_news = News.create(
                    name: res["source"]["name"] || "",
                    author: res["author"] || "",
                    image: res["urlToImage"] || "",
                    title: res["title"] || "",
                    description: res["description"] || "",
                    content: res["content"] || "",
                    url: res["url"] || "",
                    published_at: res["publishedAt"],
                  )
                  trendingNews << {
                    name: trending_news.name || "",
                    author: trending_news.author || "",
                    image: trending_news.image || "",
                    title: trending_news.title || "",
                    description: trending_news.description || "",
                    content: trending_news.content || "",
                    url: trending_news.url || "",
                    publishedAt: Time.parse(trending_news.published_at.to_s).strftime("%d/%m/%y") || "",
                  }
                end
              else
                news.each do |res|
                  trendingNews << {
                    name: res.name || "",
                    author: res.author || "",
                    image: res.image || "",
                    title: res.title || "",
                    description: res.description || "",
                    content: res.content || "",
                    url: res.url || "",
                    publishedAt: Time.parse(res.published_at.to_s).strftime("%d/%m/%y") || "",
                  }
                end
              end
              leagues_data = League.all
              leagues_data.each do |league|
                leagues << {
                  tournamentId: league.tournament_id,
                  tournamentName: league.tournament_name,
                  image: league.image,
                }
              end
              { status: 200, message: MSG_SUCCESS, liveMatches: liveMatches || [], upcomingMatches: upcomingMatches || [], trendingNews: trendingNews || [], leagues: leagues || [] }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- homeApi --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
