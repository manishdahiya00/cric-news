

module API
  module V1
    class LiveMatchData < Grape::API
      include API::V1::Defaults


      #####################################################################
		  #############	====>    	    	Match Squads API
			#####################################################################


      resource :liveMatchData do
        params do
          use :common_params
          requires :matchId,type:String,allow_blank:false
          requires :compId,type:String,allow_blank:false
        end
        post do
          begin
           device = DeviceDetail.find_by(device_id: params[:deviceId],security_token: params[:securityToken])
           if device.present?
            require "rest-client"
            match_data_url = "https://rest.entitysport.com/v2/competitions/#{params[:compId]}/squads/#{params[:matchId]}?token=e9a8cd857f01e5f88127787d3931b63a"
            match_data_res = RestClient.get(match_data_url)
            scorecard_url = "https://rest.entitysport.com/v2/matches/#{params[:matchId]}/scorecard?token=e9a8cd857f01e5f88127787d3931b63a"
            match_data = JSON.parse(match_data_res)
            scorecard_res = RestClient.get(scorecard_url)
            scorecard_data = JSON.parse(scorecard_res)
            match = Match.find_by(mid: params[:matchId])
            teama = match_data["response"]["squads"][0]["players"]
            teamb = match_data["response"]["squads"][1]["players"]
            data = {
              teama_name: match.teama_name,
              teama_short_name:  match_data["response"]["squads"][0]["team"]["abbr"],
              teamb_name: match.teamb_name,
              teamb_short_name: match_data["response"]["squads"][1]["team"]["abbr"],
              teama_logo: match.teama_logo,
              teamb_logo: match.teamb_logo,
              teama_scores: match.teama_scores_full,
              teamb_scores: match.teamb_scores_full,
              match_type: match.match_type,
              teama_players: teama,
              teamb_players: teamb,
              scores: {
                teama: scorecard_data["response"]["innings"][0],
                teamb: scorecard_data["response"]["innings"][1]
              }
            }
            {status: 200, message: MSG_SUCCESS, matchData: data}
           else
            {status: 500, message: "No Device Found"}
           end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- liveMatchDataApi --- Params: #{params.inspect}  Error: #{e.message}"
            {status: 500, message: MSG_ERROR, error: e}
          end
        end
      end
    end
  end
end
