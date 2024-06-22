module API
  module V1
    class DatewiseUpdates < Grape::API
      include API::V1::Defaults


      #####################################################################
		  #############	====>    	    	Datewise Updates API
			#####################################################################

      resource :datewiseUpdates do
        before {api_params}

        params do
          use :common_params
          requires :dateFrom, type: DateTime, allow_blank: false
          requires :dateTo, type: DateTime, allow_blank: false
        end
        post do
          begin
            @device_detail = DeviceDetail.find_by(device_id: params[:deviceId],security_token: params[:securityToken])

            if @device_detail.present?
              require "rest-client"
              news = []
              matches = []
              date_news_url = "https://newsapi.org/v2/top-headlines?country=in&category=sports&q=cricket&from=#{params[:dateFrom]}&to=#{params[:dateTo]}&apiKey=c3d60ac64c52432cad1a4f43dd4ec732"
              date_news_res = RestClient.get(date_news_url)
              date_news = JSON.parse(date_news_res)
              match_data = Match.where("match_time LIKE ?", params[:dateFrom])
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
                matches << {
                  match_id: match.mid,
                  competition_id: match.cid,
                  title: match.title,
                  short_title: match.short_title,
                  type: match.match_type,
                  teama: match.teama_name,
                  teama_logo: match.teama_logo,
                  teamb: match.teamb_name,
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
                  match_time: match.match_time
                }
              end
              {status: 200, message: MSG_SUCCESS, news: news || [], matches: matches || []}
            else
              {status: 500, message: "No Device Found"}
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- datewiseUpdates --- Params: #{params.inspect}  Error: #{e.message}"
            {status: 500, message: MSG_ERROR, error: e}
          end
        end
      end
    end
  end
end
