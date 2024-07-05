module API
  module V1
    class DatewiseUpdates < Grape::API
      include API::V1::Defaults

      resource :datewiseUpdates do
        before { api_params }

        params do
          use :common_params
          requires :dateFrom, type: DateTime, allow_blank: false
          requires :dateTo, type: DateTime, allow_blank: false
        end

        post do
          begin
            @user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])

            if @user.present?
              require "rest-client"
              news = []
              matches = []

              date_news_url = "https://newsapi.org/v2/top-headlines?country=in&category=sports&q=cricket&from=#{params[:dateFrom]}&to=#{params[:dateTo]}&apiKey=c3d60ac64c52432cad1a4f43dd4ec732"
              date_news_res = RestClient.get(date_news_url)
              date_news = JSON.parse(date_news_res)
              start_date = params[:dateFrom].beginning_of_day
              end_date = params[:dateTo].end_of_day
              match_data = Match.where(match_time: start_date..end_date)

              date_news["articles"].each do |res|
                news << {
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

              match_data.each do |match|
                match_data_url = "https://rest.entitysport.com/v2/competitions/#{match.cid}/squads/#{match.mid}?token=e9a8cd857f01e5f88127787d3931b63a"
                match_data_res = RestClient.get(match_data_url)
                match_data_for_players = JSON.parse(match_data_res)
                teama = match_data_for_players["response"]["squads"][0]["players"]
                teamb = match_data_for_players["response"]["squads"][1]["players"]
                matches << {
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
                  teama_players: teama,
                  teamb_players: teamb,
                }
              end

              { status: 200, message: MSG_SUCCESS, news: news || [], matches: matches || [] }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- datewiseUpdates --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
