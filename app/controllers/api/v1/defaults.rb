###################################################
###########*******Match Types********##############
################   Upcoming => 1  #################
################   Completed => 2 #################
################   Live => 3      #################
###################################################

module API
  module V1
    module Defaults
      extend Grape::API::Helpers

      MSG_SUCCESS = "Success"
      MSG_ERROR = "Error"

      def self.included(base)
        base.prefix :api
        base.version :v1
        base.format :json

        base.helpers do
          params :common_params do
            requires :deviceId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
          end

          def api_params
            Rails.logger.info "API params ==> #{params.inspect}"
          end

          def fetch_matches(matchType)
            data = []
            if matchType == "upcoming"
              matches = Match.where(status: "Upcoming")
              matches.each do |match|
                match_data = {
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
                  match_time: match.match_time,
                }
                data << match_data
              end
            elsif matchType == "live"
              matches = Match.where(status: "Live")
              matches.each do |match|
                match_data = {
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
                  match_time: match.match_time,
                }
                data << match_data
              end
            end
            data
          end
        end
      end
    end
  end
end
