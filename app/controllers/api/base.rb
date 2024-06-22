module API
    class Base < Grape::API
      mount API::V1::DeviceDetails
      mount API::V1::AppOpenApi
      mount API::V1::HomeApi
      mount API::V1::LiveMatchData
      mount API::V1::Search
      mount API::V1::DatewiseUpdates
    end
end
