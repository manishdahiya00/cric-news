module API
  class Base < Grape::API
    mount API::V1::UserDetails
    mount API::V1::AppOpenApi
    mount API::V1::HomeApi
    mount API::V1::LiveMatchData
    mount API::V1::Search
    mount API::V1::DatewiseUpdates
    mount API::V1::PlayerData
    mount API::V1::AllPlayers
    mount API::V1::PlayerSearch
    mount API::V1::LeaguesData
    mount API::V1::Profile
    mount API::V1::NewsDetails
  end
end
