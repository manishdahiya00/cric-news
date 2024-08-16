require "rest-client"

module API
  module V1
    class DatewiseUpdates < Grape::API
      include API::V1::Defaults

      resource :datewiseUpdates do
        before { api_params }

        params do
          use :common_params
          requires :dateFrom, type: DateTime, desc: "Start Date"
          requires :dateTo, type: DateTime, desc: "End Date"
        end

        post do
          begin
            @user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])

            unless @user
              return { status: 500, message: "No User Found" }
            end

            news = fetch_or_cache_news(params[:dateFrom], params[:dateTo])
            matches = fetch_or_cache_matches(params[:dateFrom], params[:dateTo])

            { status: 200, message: MSG_SUCCESS, news: news, matches: matches }
          rescue RestClient::ExceptionWithResponse => e
            Rails.logger.error "RestClient Error: #{e.message}"
            { status: 500, message: "External API error", error: e.message }
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error "User not found: #{e.message}"
            { status: 404, message: "User not found", error: e.message }
          rescue StandardError => e
            Rails.logger.error "Internal Server Error: #{e.message}"
            { status: 500, message: "Internal server error", error: e.message }
          end
        end
      end

      helpers do
        def fetch_or_cache_news(date_from, date_to)
          Rails.cache.fetch("datewise_news_#{date_from}_to_#{date_to}", expires_in: 1.hour) do
            fetch_news(date_from, date_to)
          end
        end

        def fetch_or_cache_matches(date_from, date_to)
          Rails.cache.fetch("datewise_matches_#{date_from}_to_#{date_to}", expires_in: 1.hour) do
            fetch_matches(date_from, date_to)
          end
        end

        def fetch_news(date_from, date_to)
          news_data = News.where("published_at >= ?", date_from - 1.day)

          if news_data.empty?
            news_response = fetch_news_from_api(date_from, date_to)
            save_news_from_response(news_response)
          else
            format_news(news_data)
          end
        end

        def fetch_news_from_api(date_from, date_to)
          url = "https://newsapi.org/v2/everything?q=cricket&from=#{date_from}&to=#{date_to}&apiKey=#{NEWS_API_KEY.sample}"
          response = RestClient.get(url)
          JSON.parse(response.body)["articles"]
        end

        def save_news_from_response(news_response)
          news_response.map do |res|
            News.create(
              name: res["source"]["name"] || "",
              author: res["author"] || "",
              image: res["urlToImage"] || "",
              title: res["title"] || "",
              description: res["description"] || "",
              content: res["content"] || "",
              url: res["url"] || "",
              published_at: Time.parse(res["publishedAt"]).strftime("%d/%m/%y"),
            )
          end
        end

        def format_news(news_data)
          news_data.map do |res|
            {
              name: res.name,
              author: res.author,
              image: res.image,
              title: res.title,
              description: res.description,
              content: res.content,
              url: res.url,
              publishedAt: res.published_at.strftime("%d/%m/%y"),
            }
          end
        end

        def fetch_matches(date_from, date_to)
          start_date = date_from.beginning_of_day
          end_date = date_to.end_of_day
          matches_data = Match.where(match_time: start_date..end_date)

          matches_data.map do |match|
            team = Team.find_by(mid: match.mid)
            if match.teama_name && match.teamb_name && team.present?
              {
                match_id: match.mid,
                competition_id: match.cid,
                title: match.title,
                short_title: match.short_title,
                type: match.match_type,
                teama: match.teama_name[0, 11] + "...",
                teama_logo: match.teama_logo,
                teamb: match.teamb_name[0, 11] + "...",
                teamb_logo: match.teamb_logo,
                venue: {
                  name: match.venue_name,
                  location: match.venue_location,
                  country: match.venue_country,
                },
                teama_scores_full: match.teama_scores_full,
                teama_scores: match.teama_scores,
                teama_overs: match.teama_overs,
                teamb_scores_full: match.teamb_scores_full,
                teamb_scores: match.teamb_scores,
                teamb_overs: match.teamb_overs,
                match_time: match.match_time,
                teama_players: team.teama || [],
                teamb_players: team.teamb || [],
              }
            else
              fetch_match_data_from_api(match)
            end
          end
        end

        def fetch_match_data_from_api(match)
          match_data_url = "https://rest.entitysport.com/v2/competitions/#{match.cid}/squads/#{match.mid}?token=e9a8cd857f01e5f88127787d3931b63a"
          match_data_res = RestClient.get(match_data_url)
          match_data_for_players = JSON.parse(match_data_res.body)

          team = Team.create(
            mid: match.mid,
            match_type: match.match_type,
            teama_name: match_data_for_players["response"]["squads"][0]["team"]["title"],
            teamb_name: match_data_for_players["response"]["squads"][1]["team"]["title"],
            teama_abbr: match_data_for_players["response"]["squads"][0]["team"]["abbr"],
            teamb_abbr: match_data_for_players["response"]["squads"][1]["team"]["abbr"],
            teama_url: match_data_for_players["response"]["squads"][0]["team"]["logo_url"],
            teamb_url: match_data_for_players["response"]["squads"][1]["team"]["logo_url"],
            teama_scores: match.teama_scores_full,
            teamb_scores: match.teamb_scores_full,
            teama: match_data_for_players["response"]["squads"][0]["players"],
            teamb: match_data_for_players["response"]["squads"][1]["players"],
          )

          {
            match_id: match.mid,
            competition_id: match.cid,
            title: match.title,
            short_title: match.short_title,
            type: match.match_type,
            teama: team.teama_name[0, 11] + "...",
            teama_logo: team.teama_url,
            teamb: team.teamb_name[0, 11] + "...",
            teamb_logo: team.teamb_url,
            venue: {
              name: match.venue_name,
              location: match.venue_location,
              country: match.venue_country,
            },
            teama_scores_full: match.teama_scores_full,
            teama_scores: match.teama_scores,
            teama_overs: match.teama_overs,
            teamb_scores_full: match.teamb_scores_full,
            teamb_scores: match.teamb_scores,
            teamb_overs: match.teamb_overs,
            match_time: match.match_time,
            teama_players: match_data_for_players["response"]["squads"][0]["players"],
            teamb_players: match_data_for_players["response"]["squads"][1]["players"],
          }
        end
      end
    end
  end
end
